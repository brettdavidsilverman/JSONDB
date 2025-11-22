<?php

require_once "Parser.php";


class JSONDBListener implements  \JsonStreamingParser\Listener\ListenerInterface
{

    public $valueCount = 0;
    public $path = null;
    public $newPath = null;
    public $jobPath = null;
    public $credentials = null;
    
    protected $stack;
    protected $connection;
    
    protected $stream;
    protected $updateValueId;
    
    protected $replaceValueId;
    protected $lockedValueId;
    protected $stagingValueId;
    protected $parentValueId;
    
    protected $lock = true;
    protected $appendToArray;
    protected $objectKey;
    protected $objectIndex;
    
    protected $startTime = null;
    protected $nextTime = null;
    
    
    protected $totalValueCount;
    protected $startTimer;
    
    protected $insertValueStatement = null;
    
    public function __construct(
        $connection,
        $credentials, 
        $path,
        $object = null,
        $stream = null,
        $jobPath
    )
    {
        $this->connection = $connection;
        $this->jobPath = $jobPath;
        $this->path = $path;
        $this->credentials = $credentials;
        $useNullObject = false;
        
        if (is_null($stream)) {
            $useNullObject = true;
            $stream = fopen('php://temp','w+');
            
        }
        
        if (!is_null($object) || $useNullObject) {
            // Get json string
            $string = json_encode($object);
            fwrite($stream, $string);
            rewind($stream);
        }
              
        $this->stream = $stream;
        

        $this->totalValueCount =
           $this->getTotalValueCount($stream);

        if ($this->cancelled()) {
            throw new CancelException($this);
        }
        
    }

    public function writeToDatabase() {
        
        $parser = new \JsonStreamingParser\Parser(
            $this->stream,
            $this
        );
        
        $parser->parse();
        
        if (!empty($this->stack))
           throw new Exception("Invalid stack");
     
        return $this->newPath;
    }
    
    public function writeToJob(
        $path,
        $object
    )
    {

        if (!is_null($this->jobPath)) {

            writeToDatabase(
                $this->credentials,
                $this->jobPath . $path,
                $object
            );
    
        }

    }

    public function readFromJob(
        $path
    )
    {

        $object = null;

        if (!is_null($this->jobPath)) {

            $object = readFromDatabase(
                $this->credentials,
                $this->jobPath . $path
            );
        }

        return $object;

    }

    protected function cancelled() {

        $cancel = $this->readFromJob(
            "/cancel"
        );
        
        return ($cancel === true);
        
    }

    public function startDocument(): void
    {

     
        $this->writeToJob(
            "/label",
            "Indexing"
        );

        $this->writeToJob(
            "/progress",
            0.0
        );


        $this->writeToJob(
            "/jobPath",
            $this->jobPath
        );
        
        $this->startTime = time();
        $this->nextTime = time();
        $this->newPath = $this->path;
        $this->lock = ($this->totalValueCount > 1);

  
        $this->getPathValueId();

        
    }
    
    
    public function endDocument() : void
    {

        $this->resetInsertValueStatement();
        

        $top = array_pop($this->stack);
    
        $ownerId =
            $this->credentials["userId"];
            
        if ($this->totalValueCount > 1) {
        
            if (!is_null($this->jobPath)) {
                $jobStatus = 
                    $this->readFromJob("");
                
                $jobStatus["label"] = "Committing";
                $jobStatus["progress"] = 100;
                unset($jobStatus["cancel"]);
            
                $this->writeToJob(
                    "",
                    $jobStatus
                );
            }
            

            $statement = $this->connection->prepare(
                "CALL endDocument(?, ?, ?, ?, ?, ?);"
            );

            $statement->bind_param(
                'iiiiii',
                $ownerId,
                $this->replaceValueId,
                $this->lockedValueId,
                $this->parentValueId,
                $this->stagingValueId,
                $this->appendToArray
            );

$msg = "ownerId: " . $ownerId . ", " .
       "replaceValueId: " . $this->replaceValueId  . ", " .
       "lockedValueId: " . $this->lockedValueId . ", " .
       "parentValueId: " . $this->parentValueId . ", " .
       "stagingValueId: " . $this->stagingValueId . ", " .
       "appendToArray: " . ($this->appendToArray ? 1 : 0);

            $statement->execute();
       
            $statement->close();
        }

        
        if (is_null($this->newPath))
        {
            
            $this->newPath =
                getPathByValueId(
                    $this->connection,
                    $this->stagingValueId,
                    $ownerId
                );
        }
  
        

        if ($this->totalValueCount > 1 &&
            !is_null($this->jobPath))
        {
            $jobStatus =
                $this->readFromJob(
                    ""
                );
        
            if (is_null($jobStatus))
               $jobStatus = [];
               
            $jobStatus = array_merge(
                $jobStatus,
                [
                    "label" => "Success",
                    "path" => $this->path,
                    "newPath" => $this->newPath,
                    "jobPath" => $this->jobPath,
                    "timeTaken" => 
                       (time() - $this->startTime),
                    "done" => true
                ]
            );
                
            unset($jobStatus["progress"]);
            unset($jobStatus["cancel"]);
            
            $this->writeToJob(
                "",
                $jobStatus
            );
            
            
        }
        

    }

    public function cancelDocument()
    {

        $this->resetInsertValueStatement();
        
        $this->writeToJob(
            "/label",
            "Cancelling"
        );
        
        
        if (!is_null($this->lockedValueId)) {
            
            $statement = $this->connection->prepare(
                "CALL deleteLockedValues(?);"
            );

            $statement->bind_param(
                'i',
                $this->lockedValueId
            );

            $statement->execute();
        
            $statement->close();

        }
        
        $jobStatus =
            $this->readFromJob(
                ""
            );
            

        if (!is_null($jobStatus)) {
        
            unset($jobStatus["progress"]);
            unset($jobStatus["cancel"]);
            
            $jobStatus["label"] = "Cancelled";
            
            $this->writeToJob(
                "",
                $jobStatus
            );
            
        }

    
    }
    
    private function resetInsertValueStatement()
    {
        if (!is_null($this->insertValueStatement)) {
            $this->insertValueStatement->close();
            $this->insertValueStatement = null;
        }

    }
    
    public function getPathValueId() {

                 
        
        $parentValueId = null;

        $this->appendToArray = false;
        $this->newPath = $this->path;
        $this->updateValueId = null;
        $this->objectIndex = null;
        
        $parentValueId =
            $this->firstSegment(
                $type
            );
            
        $parentValueId =
            $this->middleSegments(
                $parentValueId,
                $type
            );

        $parentValueId =
           $this->lastSegment(
               $parentValueId,
               $type
           );

        $this->parentValueId =
            $parentValueId;
            
        $this->stack = [
            [
                "parentValueId" => $parentValueId,
                "objectIndex" => $this->objectIndex
            ]
        ];
        
        
        return $parentValueId;


    }

    protected function firstSegment(
        & $type
    )
    {


        $paths = explode('/', $this->path);

        $count = count($paths);
        
        if ($count <= 1)
           throw new PathException("Invalid path", $this, null);
           
        $segment = decodePathSegment($paths[1]);
        $nextSegment = null;
        if ($count > 2)
            $nextSegment = decodePathSegment($paths[2]);
            
        $ownerId = null;
        $userId = 
            $this->credentials["userId"];


        if ($count >= 2)
        {
            if ($segment === 'my') {
                $ownerId = $userId;
            }
            else if (is_int($segment))
                $ownerId = $segment;
        }
        else
            $ownerId = $userId;
        
        $statement = $this->connection->prepare(
            "CALL getRootValueId(?,?);"
        );

        $statement->bind_param(
            'ii', 
            $userId,
            $ownerId
        );

        $statement->execute();
    
        $statement->bind_result(
            $valueId,
            $type
        );

        $statement->fetch();
    
        $statement->close();
        
        if ($count === 2) {
            if ($this->totalValueCount === 1)
                $this->updateValueId = $valueId;
            else
                $this->replaceValueId = $valueId;
            return null;
        }
    
        if (is_null($valueId) &&
            $count > 2)
        {
            $this->lock =
               ($this->totalValueCount > 1);

            if ($nextSegment === "$")
                $type = "array";
            else
                $type = "object";
                
            $valueId =
                $this->insertValue(
                    true,
                    $userId, # $ownerId
                    null, # $parentValueId,
                    $this->replaceValueId, // $replaceValueId
                    $this->lock, //$locked,
                    $type, # $type
                    $objectIndex, # & objectIndex
                    null,  # $objectKey,
                    false, # $isNull,
                    null,  # $stringValue,
                    null,  # $numericValue,
                    null   # $boolValue
               );


        }
        else
            $this->replaceValueId = $valueId;
            
        

        return $valueId;
    }
    
    protected function middleSegments(
        $parentValueId,
        & $type
    )
    {
        $segment = null;
        $ownerId = $this->credentials["userId"];

        $paths = explode("/", $this->path);
        $count = count($paths);
        $valueId = $parentValueId;


        for($i = 2; $i < ($count - 1); ++$i) {
            
            $segment = decodePathSegment($paths[$i]);
            $nextSegment = decodePathSegment($paths[$i + 1]);

            if ($segment === "")
                throw new PathException("Empty path", $this, $i);
 
            if (is_int($nextSegment) ||
                $nextSegment === "$")
            {
                $type = "array";
            }
            else
                $type = "object";
                    
            $objectIndex = null;
            
            if ($segment === "$") {
                $this->newPath = null;
                $this->replaceValueId = null;
                #$this->lock = false;
                $valueId =
                    $this->insertValue(
                        true,
                        $ownerId,
                        $parentValueId, // $parentValueId,
                        $this->replaceValueId, // $replaceValueId
                        $this->lock, // $locked
                        $type, // $type,
                        $objectIndex,
                        null, // $objectKey,
                        false, //$isNull,
                        null, //$stringValue,
                        null, //$numericValue,
                        null  //$boolValue
                    );

            }
            else {
                $valueId =
                    $this->getOrInsertValue(
                        $parentValueId,
                        $i,
                        $type
                    );
            }

            $parentValueId = $valueId;
        }

    
        return $valueId;

    }

    protected function lastSegment(
        $parentValueId,
        $preceedingType
    )
    {
        $userId = $this->credentials["userId"];

        $paths = explode("/", $this->path);
        $count = count($paths);

        if ($count <= 2) {
            return $parentValueId;
        }
            
        $segment = decodePathSegment($paths[$count - 1]);
        
        if ($segment === "")
            throw new PathException("Empty path", $this, $count - 1);
                
        $objectKey = null;
        $objectIndex = null;
        
        if (is_int($segment))
            $objectIndex = $segment;
        else
            $objectKey = $segment;

        if ($segment === "$")
        {
            $this->newPath = null;
            $this->appendToArray = true;
            $objectKey = null;
            $objectIndex = null;
            $this->replaceValueId = null;
        }
        else {
            // Get the object key
            $valueId =
                $this->getValueId(
                    $parentValueId,
                    $objectIndex,
                    $objectKey,
                    $type,
                    $locked
                );
                

            if ($locked) {
                throw new LockedException("Path locked", $this, $count - 1);
            }

            if (!is_null($valueId)) {
        
                // If only one value,
                // update
                if ($this->totalValueCount === 1)
                {
                    $this->updateValueId =
                        $valueId;
                }
                
                if (!is_int($segment) &&
                     $preceedingType != "object")
                {
                    throw new PathException("Expecting object", $this, $count - 1);
                }
            
                
            }
            
            $this->replaceValueId =
                $valueId;

        }
    

        $this->objectKey = $objectKey;
        $this->objectIndex = $objectIndex;
        
        return $parentValueId;

    }

    protected function getOrInsertValue(
        $parentValueId,
        $i,
        & $type
    )
    {
        $paths = explode("/", $this->path);
        $count = count($paths);
        $last = ($i === ($count - 1));
        
        $segment = decodePathSegment($paths[$i]);
        $nextSegment = null;
        if (!$last)
            $nextSegment = decodePathSegment($paths[$i + 1]);

        $ownerId = $this->credentials["userId"];

        $objectIndex = null;
        $objectKey = null;
   

        if (is_int($segment)) {
            $objectIndex = $segment;
        }
        else {
            $objectKey = $segment;
        }

        $valueId = $this->getValueId(
            $parentValueId,
            $objectIndex,
            $objectKey,
            $type,
            $locked
        );
        
        if (!is_null($valueId)) {
            $this->replaceValueId = $valueId;
        }
        
        if ($locked) {
            throw new LockedException("Path locked", $this, $i);
        }

        if (is_null($valueId) &&
            is_int($segment))
        {
            $objectIndex = $segment;
        }

        if (!is_null($valueId) && !$last)
        {
            if (is_int($nextSegment))
            {
                if ($type != "array" &&
                    $type != "object")
                    throw new PathException("Expected array or object type", $this, $i);
            }
            else if ($nextSegment === "$")  {
                if ($type != "array")
                    throw new PathException("Expecting array", $this, $i);
            }
            else {
                if ($type != "object")
                    throw new PathException("Expected object type", $this, $i);
            }
        }

        if (is_null($valueId) && !$last)
        {
            if (is_int($nextSegment) ||
                $nextSegment === "$")
            {
                $type = "array";
            }
            else
                $type = "object";

            $objectIndex = null;
            $valueId =
                $this->insertValue(
                    true,
                    $ownerId,
                    $parentValueId, // $parentValueId,
                    $this->replaceValueId, // $replaceValueId
                    $this->lock, // $locked
                    $type, // $type,
                    $objectIndex,
                    $objectKey, // $objectKey,
                    false, //$isNull,
                    null, //$stringValue,
                    null, //$numericValue,
                    null  //$boolValue
                );
                

 

        }

    
        $this->objectKey = $objectKey;
        
        if (is_null($valueId))
            return $parentValueId;
        
        return $valueId;

          
    }

    protected function getValueId(
        $parentValueId,
        & $objectIndex,
        & $objectKey,
        & $type,
        & $locked
    )
    {

        $statement = $this->connection->prepare(
            "CALL getValueId(?,?,?,?);"
        );

        $userId =
            $this->credentials["userId"];
            
        $statement->bind_param(
            'iiis', 
            $userId,
            $parentValueId,
            $objectIndex,
            $objectKey
        );

        $statement->execute();
    
        $statement->bind_result(
            $valueId,
            $type,
            $locked,
            $objectIndex,
            $objectKey
        );
    
        $statement->fetch();

        $statement->close();
        

        return $valueId;
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
        $this->objectKey = $key;
        
    }

    public function value($value): void
    {
        
        $this->createValue($value);
        
        if (is_null($this->jobPath)) {
            return;
        }
            
        if (time() > $this->nextTime)
        {
            set_time_limit(30);

            if ($this->cancelled()) {
                throw new CancelException($this);
            }

            $progress = (
                $this->valueCount /
                $this->totalValueCount *
                100.0
            );

 
            $this->writeToJob(
                "/progress",
                $progress
            );

            $this->nextTime = time() + 5;

        }
   
        
    }
    
    
    
    protected function startComplexValue($type)
    {
        $valueId = $this->createValue(null, $type);
        $this->stack[] = [
           "parentValueId" => $valueId,
           "objectIndex" => 1
        ];
        
        
    }

    protected function endComplexValue(): void
    {
        array_pop($this->stack);
    }
    
    public function whitespace(string $whitespace): void
    {
    }

    // Inserts the given value into the top value on the stack in the appropriate way,
    // based on whether that value is an array or an object.
    protected function createValue($value, $type = null)
    {
        $this->valueCount++;
        
        $valueId = null;
        
        // Grab the top item from the stack that we're currently parsing.

        $top = array_pop($this->stack);
        $parentValueId = $top["parentValueId"];
        $objectIndex = $top["objectIndex"]++;
        $ownerId =
            $this->credentials["userId"];
       
            
        $objectKey = $this->objectKey;

        $boolValue = null;
        $isNull = null;
        $stringValue = null;
        $numericValue = null;
        
        if (is_null($type)) {
            if (is_null($value)) {
                $isNull = true;
                $type = "null";
            }
            else {
                $isNull = false;
                if (is_string($value)) {
                    $stringValue = $value;
                    $type = "string";
                }
                else if (is_numeric($value)) {
                    $numericValue = $value;
                    $type = "number";
                }
                else if (is_bool($value)) {
                    $boolValue = $value;
                    $type = "bool";
                }
            }
        }
        else
            $isNull = false;
        
     
        if (!is_null($this->updateValueId))
        {

            // update
            $valueId = $this->updateValueId;

            $this->updateValue(
                $valueId,
                $ownerId,
                false, # $locked
                $type,
                $objectKey,
                $isNull,
                $stringValue,
                $numericValue,
                $boolValue
            );
            
            
        }
        else {

            // Insert
            $valueId =
                $this->insertValue(
                    false,
                    $ownerId,
                    $parentValueId,
                    $this->replaceValueId,
                    $this->lock, //$locked,
                    $type,
                    $objectIndex,
                    $objectKey,
                    $isNull,
                    $stringValue,
                    $numericValue,
                    $boolValue
               );
        }
        
        if (is_null($this->stagingValueId))
            $this->stagingValueId = $valueId;

        $this->objectKey = null;
    
        $this->stack[] = $top;

        return $valueId;
    }

    
    protected function deleteChildValues(
        $valueId
    )
    {
        $sql = "CALL deleteChildValues(?)";
        
        $this->connection->execute_query(
           $sql,
           [$valueId]
        );
    
    }

    
    
    protected function insertValue(
       $resetStatement,
       $ownerId,
       $parentValueId,
       $replaceValueId,
       $lock,
       $type,
       & $objectIndex,
       $objectKey,
       $isNull,
       $stringValue,
       $numericValue,
       $boolValue
    )
    {
        
        
        $statement = $this->insertValueStatement;
        
        static $_ownerId = null;
        static $_parentValueId = null;
        static $_replaceValueId = null;
        static $_lock = null;
        static $_type = null;
        static $_objectIndex = null;
        static $_objectKey = null;
        static $_isNull = null;
        static $_stringValue = null;
        static $_numericValue = null;
        static $_boolValue = null;
        
        if (is_null($statement)) {
            $statement = 
                $this->connection->prepare(
                    "CALL insertValue(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                );
            
            $statement->bind_param(
                "iiiisisisdi",
                $_ownerId,
                $_parentValueId,
                $_replaceValueId,
                $_lock,
                $_type,
                $_objectIndex,
                $_objectKey,
                $_isNull,
                $_stringValue,
                $_numericValue,
                $_boolValue
            );
            
            $this->insertValueStatement = $statement;
            
        }
        
        $_ownerId = $ownerId;
        $_parentValueId = $parentValueId;
        $_replaceValueId = $replaceValueId;
        $_lock = $lock;
        $_type = $type;
        $_objectIndex = $objectIndex;
        $_objectKey = $objectKey;
        $_isNull = $isNull;
        $_stringValue = $stringValue;
        $_numericValue = $numericValue;
        $_boolValue = $boolValue;

        $statement->execute();

        $statement->bind_result(
            $valueId,
            $objectIndex
        );
    
        $statement->fetch();

        if ($resetStatement === true)
        {
            $this->resetInsertValueStatement();
        }
        
        if ($lock) {
            $this->lockedValueId = $valueId;
            $this->lock = false;
        }
        
        return $valueId;
       
    }

    
    protected function updateValue(
       $valueId,
       $ownerId,
       $locked,
       $type,
       $objectKey,
       $isNull,
       $stringValue,
       $numericValue,
       $boolValue
    )
    {
        
        $statement = 
            $this->connection->prepare(
                "CALL updateValue(?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );
        

        $statement->bind_param(
            'iiissisdi',
            $valueId,
            $ownerId,
            $locked,
            $type,
            $objectKey,
            $isNull,
            $stringValue,
            $numericValue,
            $boolValue
        );

        $statement->execute();
        
        $statement->close();
        
    }
    /*
    protected function insertValueWords(
        $valueId,
        $objectKey,
        $stringValue
    )
    {

        $this->insertParentValueWords(
            $valueId
        );
        
 
        $words1 =
            $this->getTokens($objectKey);
            
        $words2 = 
            $this->getTokens($stringValue);
            
        $words = array_merge($words1, $words2);
        
        // sort to avoid dead locks
        sort($words);
            
        // prepare the statement
        $statement = 
            $this->connection->prepare(
                "CALL insertValueWord(?, ?)"
            );
        
        $statement->bind_param(
            'is',
            $valueId,
            $word
        );
            
 
        // insert each word
        foreach ($words as $word) {
            if (!is_null($word)) {
                $word = strtolower($word);
                $statement->execute();
            }
        }
        
        $statement->close();
        

    }
    
    
    protected function insertParentValueWords(
        $valueId
    )
    {

        // prepare the statement
        $statement = 
            $this->connection->prepare(
                "CALL insertParentValueWords(?)"
            );
        
        $statement->bind_param(
            'i',
            $valueId
        );
            
        $statement->execute();
        
        $statement->close();
    }
    */
    protected function getTokens($string)
    {
        if (is_null($string))
           return [];
           
        
        if (strlen($string) === 1)
           return [$string];
           
        $delimiter =
            ",“.”\'()*\'\"{}:;!?`|[] \t\r\n";
            
        $words = [];
        
        // tokenize object key
        $token = strtok(
            $string,
            $delimiter
        );
        
        while ($token !== false) {
            $words[] = strtolower($token);
            $token = strtok($delimiter);
        }
        
        return $words;
        
    }
    
    protected function getTotalValueCount($stream) {
        
        $valueCountListener = new ValueCountListener();
        $valueCountParser = new \JsonStreamingParser\Parser(
            $stream,
            $valueCountListener
        );
    
        $valueCountParser->parse();
    
        if (!$valueCountListener->result)
            throw new Exception(
                "Unexpected end of data"
            );
                
        $totalValueCount =
             $valueCountListener->valueCount;
    
        // Reset the stream to start inserting
        rewind($stream);

        return $totalValueCount;
    }
    
}

?>