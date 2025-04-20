<?php

require_once "Parser.php";


class JSONDBListener implements  \JsonStreamingParser\Listener\ListenerInterface
{
    
    protected $result;

    /**
     * @var array
     */
    protected $stack;
 
 
    /**
     * @var string[]
     */
    protected $keys;
    
    protected $connection;
    protected $credentials;
    protected $createValueStatement = null;
    protected $pathValueId;
    
    public $valueCount = 0;
    protected $totalValueCount;
    protected $startTime;
    
    
    public function __construct($connection, $credentials, $pathValueId, $totalValueCount) {
        
        $this->connection = $connection;
        $this->credentials = $credentials;
        $this->pathValueId = $pathValueId;
        
        $this->totalValueCount =
           $totalValueCount;
           
        $this->startTime = time();
    }
    
    

    public function getJson()
    {
        return $this->result;
    }

    public function startDocument(): void
    {
        $this->stack = [];
        $this->keys = [];

        $sessionKey =
            $this->credentials["sessionKey"];
            
        $statement =
            $this->connection->prepare(
                "CALL deleteTempValues(?);"
            );
          
        $statement->bind_param(
           's',
           $sessionKey
        );
   
        $statement->execute();
   
        $statement->close();
    
        
    }
    
    public function endDocument() : void
    {
        set_time_limit(30);
        
        setSessionStatus(
            $this->credentials,
            [
                "label"=>"Finalizing...",
                "percentage"=>100,
                "done" => false
            ]
        );
    
        if ($this->createValueStatement) {
            $this->createValueStatement->close();
            $this->createValueStatement = null;
        }
        
        $sessionKey =
           $this->credentials["sessionKey"];
        
        $statement =
           $this->connection->prepare(
              "CALL upgradeTempValues(?, ?);"
           );
          
        $statement->bind_param(
           'si',
           $sessionKey,
           $this->pathValueId
        );
   
        $statement->execute();

        $statement->close();
        
    }
    

    public function startObject(): void
    {
        $this->startComplexValue('object');
    }

    public function endObject(): void
    {
        $this->endComplexValue();
    }

    public function startArray(): void
    {
        $this->startComplexValue('array');
    }

    public function endArray(): void
    {
        $this->endComplexValue();
    }

    public function key(string $key): void
    {
        $this->keys[] = $key;
        
    }

    public function value($value): void
    {
        $this->insertValue($value);
        
        $endTime = time();
        $elapsed =
           $endTime - $this->startTime;
           
        $this->valueCount++;
        
        if ($elapsed >= 5)
        {
           set_time_limit(30);
           //$this->credentials = refresh();
           $percentage = (
             $this->valueCount /
             $this->totalValueCount *
             100.0
           );
           
           setSessionStatus(
              $this->credentials,
              [
                 "label" => "Indexing...",
                 "percentage" => $percentage,
                 "done" => false
              ]
           );
           
           $cancelled = getCancelLastUpload(
               $this->credentials
           );
           
           if ($cancelled === true)
              throw new Exception("User cancelled");

           $this->startTime = time();
           
        }
        
    }
    
    
    
    protected function startComplexValue($type)
    {
        $parentValueId = null;
        $parent = null;
        $objectKey = null;
        $objectIndex = null;
        
        if (!empty($this->stack)) {
           $parent = array_pop($this->stack);
           $parentValueId = $parent['valueId'];
        }
        
        if (!is_null($parent) &&
            ('object' === $parent['type']))
        {
            $objectKey = array_pop($this->keys);
        }
        
        if (is_null($parent))
           $objectIndex = 0;
        else
           $objectIndex = $parent["count"]++;
        
        $valueId = $this->createValue(
           $parentValueId,
           $this->credentials["userId"],
           $this->credentials["sessionKey"],
           $type,
           $objectIndex,
           $objectKey,
           false,
           null,
           null,
           null
        );
        
        // We keep a stack of complex values (i.e. arrays and objects) as we build them,
        // tagged with the type that they are so we know how to add new values.
        $currentItem = [
           'type' => $type,
           'value' => [], 
           'count' => 0,
           'valueId' => $valueId
        ];
        
        if (!is_null($parent))
           $this->stack[] = $parent;
        
        $this->stack[] = $currentItem;
        
        return $valueId;
       
    }

    protected function endComplexValue(): void
    {
        $obj = array_pop($this->stack);

        // If the value stack is now empty, we're done parsing the document, so we can
        // move the result into place so that getJson() can return it. Otherwise, we
        // associate the value
        if (empty($this->stack)) {
            $this->result = $obj['value'];
        } else {
            $this->insertValue($obj['value']);
        }
    }
    
    public function whitespace(string $whitespace): void
    {
    }

    // Inserts the given value into the top value on the stack in the appropriate way,
    // based on whether that value is an array or an object.
    protected function insertValue($value)
    {
        $valueId = null;
        
        // Grab the top item from the stack that we're currently parsing.
        $currentItem = array_pop($this->stack);

        // Examine the current item, and then:
        //   - if it's an object, associate the newly-parsed value with the most recent key
        //   - if it's an array, push the newly-parsed value to the array

        $objectIndex = null;
        $objectKey = null;
        $parentValueId = null;
        
        if (!is_null($currentItem)) {
           $objectIndex = $currentItem['count']++;
           if ('object' === $currentItem['type']) {
              $objectKey = array_pop($this->keys);
           }
           $parentValueId = $currentItem["valueId"];
        }
        else
           $objectIndex = 0;
        
       
        $boolValue = null;
        $isNull = null;
        $stringValue = null;
        $numericValue = null;
        $type = null;
       
        if (is_null($value)) {
           $isNull = true;
           $type = "null";
        }
        else {
           $isNull = false;
           if (is_numeric($value)) {
              $numericValue = $value;
              $type = "number";
           }
           else if (is_string($value)) {
              $stringValue = $value;
              $type = "string";
           }
           else if (is_bool($value)) {
              $boolValue = $value;
              $type = "bool";
           }
           else
              $type = null;
        }
       
        if (!is_null($type)) {
           $valueId = $this->createValue(
              $parentValueId,
              $this->credentials["userId"],
              $this->credentials["sessionKey"],
              $type,
              $objectIndex,
              $objectKey,
              $isNull,
              $stringValue,
              $numericValue,
              $boolValue
           );
        
        }
        
        if (!is_null($currentItem)) {
            $this->stack[] = $currentItem;
        }
        
        return $valueId;
    }
    
    protected function createValue(
       $parentValueId,
       $ownerId,
       $sessionKey,
       $type,
       $objectIndex,
       $objectKey,
       $isNull,
       $stringValue,
       $numericValue,
       $boolValue
    )
    {
    
        static $_parentValueId;
        static $_ownerId;
        static $_sessionKey;
        static $_type;
        static $_objectIndex;
        static $_objectKey;
        static $_lowerObjectKey;
        static $_isNull;
        static $_stringValue;
        static $_numericValue;
        static $_boolValue;
       
        if (is_null($this->createValueStatement)) {
            $this->createValueStatement = 
                $this->connection->prepare(
                    "CALL createValue(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                );
        
            $this->createValueStatement->bind_param(
                'iississisdi',
                $_parentValueId,
                $_ownerId,
                $_sessionKey,
                $_type,
                $_objectIndex,
                $_objectKey,
                $_lowerObjectKey,
                $_isNull,
                $_stringValue,
                $_numericValue,
                $_boolValue
            );

        }
   
        $statement = $this->createValueStatement;
        
        $_parentValueId = $parentValueId;
        $_ownerId = $ownerId;
        $_sessionKey = $sessionKey;
        $_type = $type;
        $_objectIndex = $objectIndex;
        $_objectKey = $objectKey;
        if (is_null($objectKey))
            $_lowerObjectKey = null;
        else
           $_lowerObjectKey = strtolower($objectKey);
        $_isNull = $isNull;
        $_stringValue = $stringValue;
        $_numericValue = $numericValue;
        $_boolValue = $boolValue;
        
        $statement->execute();
        
        $valueId = null;
        $statement->bind_result($valueId);

        $fetched = $statement->fetch();

        return $valueId;
       
    }
    
    
}

?>