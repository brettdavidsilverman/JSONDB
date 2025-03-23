<?php
require_once 'jsonstreamingparser/vendor/autoload.php';

class JSONDBListener extends \JsonStreamingParser\Listener\IdleListener
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
    protected $createObjectStatement;
    protected $createValueStatement;
    
    protected $lines;
    protected $pageSize = 80;
    public $nextId = 0;
    public $rootObjectId = null;
    
    public function __construct($connection) {
        
        $this->connection = $connection;
        $this->lines = [];
        /*
        $this->createObjectStatement =
           $connection->prepare(
              "CALL createObject(?, ?, ?);"
           );
        $this->createValueStatement =
           $connection->prepare(
              "CALL createValue(?, ?, ?, ?, ?, ?, ?, ?);"
           );
        */
    }

    public function getJson()
    {
        return $this->result;
    }

    public function startDocument(): void
    {
        $this->stack = [];
        $this->keys = [];
        
        $this->connection->execute_query("DELETE FROM Object WHERE ownerId = " . $_SESSION["userId"]);
        
        $this->rootObjectId =
           $this->startComplexValue('root');
        
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
        $this->insertValue($value, null);
    }
    
    
    
    protected function startComplexValue($type)
    {
       
        $parentId = null;
        
        if (!empty($this->stack)) {
           $parent = array_pop($this->stack);
           $parentId = $parent['id'];
           $this->stack[] = $parent;
        }
        
        $objectId =
           $this->createObject(
              $parentId,
              $type
           );
        
        // We keep a stack of complex values (i.e. arrays and objects) as we build them,
        // tagged with the type that they are so we know how to add new values.
        $currentItem = [
           'type' => $type,
           'value' => [], 
           'count' => 0,
           'id' => $objectId
        ];
        
        $this->stack[] = $currentItem;
        
        return $objectId;
       
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
            $this->insertValue($obj['value'], $obj['id']);
        }
    }

    // Inserts the given value into the top value on the stack in the appropriate way,
    // based on whether that value is an array or an object.
    protected function insertValue($value, $idValue)
    {
         
        // Grab the top item from the stack that we're currently parsing.
        $currentItem = array_pop($this->stack);

        // Examine the current item, and then:
        //   - if it's an object, associate the newly-parsed value with the most recent key
        //   - if it's an array, push the newly-parsed value to the array

        $objectIndex = $currentItem['count']++;
        $objectKey = null;
        
        if ('object' === $currentItem['type']) {
            $objectKey = array_pop($this->keys);
        }
        
        $objectId = $currentItem["id"];
        $boolValue = null;
        $isNull = null;
        $stringValue = null;
        $numericValue = null;
       //$idValue
       
        if (is_null($value)) {
           $isNull = true;
        }
        else {
           $isNull = false;
           if (is_numeric($value))
              $numericValue = $value;
           else if (is_string($value))
              $stringValue = $value;
           else if (is_bool($value))
              $boolValue = $value;
           else if (!is_array($value))
              $idValue = null;
        }
       
        $valueId = $this->createValue(
           $objectId,
           $objectIndex,
           $objectKey,
           $isNull,
           $stringValue,
           $numericValue,
           $boolValue,
           $idValue
        );
        
        $this->stack[] = $currentItem;

        return $valueId;
    }
    
    protected function createObject($parentId, $type)
    {
        set_time_limit(30);
   
        $userId = $_SESSION['userId'];
        
        $statement = $this->connection->prepare(
              "CALL createObject(?, ?, ?);"
           );
          
        $statement->bind_param(
           'iis',
           $userId,
           $parentId,
           $type
        );
   
        $statement->execute();
   
        $objectId = null;
        $statement->bind_result($objectId);
   
        $fetched = $statement->fetch();
   
        $statement->close();
        
        // Echo results for debug
        if (!$fetched)
           $line = 'Error';
        else
           $line = 'Object #' . 
              nullable($objectId) . ': ' .
              nullable($parentId) . ', ' .
              nullable($type);
           
        $this->printLine($line);
        
        return $objectId;
    }

    
    protected function createValue(
       $objectId,
       $objectIndex,
       $objectKey,
       $isNull,
       $stringValue,
       $numericValue,
       $boolValue,
       $idValue
    )
    {
        set_time_limit(30);
   
        $statement = $this->connection->prepare(
              "CALL createValue(?, ?, ?, ?, ?, ?, ?, ?);"
           );
        
        $statement->bind_param(
           'iisisdii',
           $objectId,
           $objectIndex,
           $objectKey,
           $isNull,
           $stringValue,
           $numericValue,
           $boolValue,
           $idValue
        );
   
        $statement->execute();
        
        $valueId = null;
        $statement->bind_result($valueId);
   
        $fetched = $statement->fetch();
        
        $statement->close();
        
        // Echo results for debug
        if (!$fetched)
           $line = 'Error';        else
           $line = 'Value #: ' .
              nullable($valueId) . ', ' .
              nullable($objectId) . ', ' .
              nullable($objectIndex) . ', ' .
              nullable($objectKey) . ', ' .
              ($isNull ? 'true' : 'false') . ', ' .
              nullable($stringValue) . ', ' .
              nullable($numericValue) . ', ' .
              nullable($boolValue) . ', ' .
              nullable($idValue);
          
       $this->printLine($line);
       
       return $valueId;
       
    }
    
    public function printLine($line) : void {
       return;
       
       $this->lines[] = $line;
       
       if (count($this->lines) > $this->pageSize) {
          echo join("\r\n", $this->lines);
          $this->lines = [];
       }
       
    }
    
    public function sendEnd($line) : void {
       
       $this->lines[] = $line;
       
       echo join("\r\n", $this->lines);
       
       $this->lines = [];
     
       echo "\r\n";

    }
    
    protected function sendChunk($chunk) : void 
    {
       // The chunk must fill the output buffer or php won't send it
       //$chunk = str_pad($chunk, 4096);
       printf("%x\r\n%s\r\n", strlen($chunk), $chunk);
    }
}

?>