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

    protected function commit() {
        $this->connection->commit();
    }
    
    protected function begin_transaction() {
        $this->connection->begin_transaction();
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

        $this->begin_transaction();

       
        $this->getPathValueId();
 
        if ($this->totalValueCount > 1) {
/*
            $statement = $this->connection->prepare(
                "CALL startDocument();"
            );

            $statement->execute();
    
            $statement->close();
            */
            $this->commit();
       }

    }
    
    
    public function endDocument() : void
    {

        set_time_limit(30);
        
        $top = array_pop($this->stack);
    
        $ownerId =
            $this->credentials["userId"];
            
        if ($this->totalValueCount > 1) {
            
            $jobStatus = 
                $this->readFromJob("");
                
            $jobStatus["label"] = "Committing";
            $jobStatus["progress"] = 100;
            unset($jobStatus["cancel"]);
            
            $this->writeToJob(
                "",
                $jobStatus
            );
            

            $this->begin_transaction();

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

        $this->commit();
        
        if (is_null($this->newPath))
        {
            
            $this->newPath =
                getPathByValueId(
                    $this->connection,
                    $this->stagingValueId
                );
        }
  
        

        if ($this->totalValueCount > 1 &&
            !is_null($this->jobPath)) {
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
    
        $this->writeToJob(
            "/label",
            "Cancelling"
        );
        
        
        if (!is_null($this->lockedValueId)) {
            $this->begin_transaction();
        
            $statement = $this->connection->prepare(
                "CALL deleteLockedValues(?);"
            );

            $statement->bind_param(
                'i',
                $this->lockedValueId
            );

            $statement->execute();
        
            $statement->close();
    
            $this->commit();
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
           
        $segment = _urldecode($paths[1]);
        $nextSegment = null;
        if ($count > 2)
            $nextSegment = _urldecode($paths[2]);
            
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

            if ($nextSegment === "[]")
                $type = "array";
            else
                $type = "object";
                
            $valueId =
                $this->insertValue(
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
            
            $segment = _urldecode($paths[$i]);
            $nextSegment = _urldecode($paths[$i + 1]);

            if ($segment === "")
                throw new PathException("Empty path", $this, $i);
 
            if (is_int($nextSegment) ||
                $nextSegment === "[]")
            {
                $type = "array";
            }
            else
                $type = "object";
                    
            $objectIndex = null;
            
            if ($segment === "[]") {
                $this->newPath = null;
                $this->replaceValueId = null;
                #$this->lock = false;
                $valueId =
                    $this->insertValue(
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
            
        $segment = _urldecode($paths[$count - 1]);
        
        if ($segment === "")
            throw new PathException("Empty path", $this, $count - 1);
                
        $objectKey = null;
        $objectIndex = null;
        
        if (is_int($segment))
            $objectIndex = $segment;
        else
            $objectKey = $segment;

        if ($segment === "[]")
        {
            $this->newPath = null;
            $this->appendToArray = true;
            $objectKey = null;
            $objectIndex = null;
            $this->replaceValueId = null;
            #$this->lock = false;
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
        
        $segment = _urldecode($paths[$i]);
        $nextSegment = null;
        if (!$last)
            $nextSegment = _urldecode($paths[$i + 1]);

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
            else if ($nextSegment === "[]")  {
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
                $nextSegment === "[]")
            {
                $type = "array";
            }
            else
                $type = "object";

            $objectIndex = null;
            $valueId =
                $this->insertValue(
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

            $this->insertValueWords(
                $valueId,
                $objectKey
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
        
        if ($this->totalValueCount > 1)
            $this->begin_transaction();
     
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

        if ($this->totalValueCount > 1)
            $this->commit();

        $this->insertValueWords(
            $valueId,
            $objectKey
        );
        
        $this->insertValueWords(
            $valueId,
            $stringValue
        );
        
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

        $statement = 
            $this->connection->prepare(
                "CALL insertValue(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );
            
        $isSingleValue =
            ($this->totalValueCount === 1);
        
        $statement->bind_param(
            "iiiiisisisdi",
            $ownerId,
            $isSingleValue,
            $parentValueId,
            $replaceValueId,
            $lock,
            $type,
            $objectIndex,
            $objectKey,
            $isNull,
            $stringValue,
            $numericValue,
            $boolValue
        );

        $statement->execute();

        $statement->bind_result(
            $valueId,
            $objectIndex
        );
    
        $statement->fetch();

        $statement->close();

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
    
    protected function insertValueWords(
        $valueId,
        $string
    )
    {
        
        if (is_null($string))
            return;

        $words =
            $this->getTokens($string);
            
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
            $statement->execute();
        }
        
        $statement->close();
    }
    
    protected function getTokens($string)
    {
        if (is_null($string))
           return [];
           
        $delimiter =
            ",“.”\'()*\'\"{}:;!?~`|[] \t\r\n\\/";
            
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