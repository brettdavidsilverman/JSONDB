<?php
   declare(strict_types=1);
   require_once '../authentication/functions.php';
   
   authenticate();
   
   header('Content-Type: text/plain');
   //header('Content-Encoding: gzip');
   echo "URI❤️\t" . $_SERVER['REQUEST_URI'] . "\r\n";
   echo "Query💜\t" . $_SERVER['QUERY_STRING'] . "\r\n";
   
   
   require_once 'jsonstreamingparser/vendor/autoload.php';

   $testfile = __DIR__.'/jsonstreamingparser/tests/data/example.json';
   $testfile = __DIR__.'/../tests/test.json';
   $testfile = __DIR__.'/../tests/large.json';
   
function escape($value) {
   return $value;
   //return mysql_real_escape_string($value);
}

   
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
    
    
    
    protected function startComplexValue($type): void
    {
       
        $parentId = null;
        
        if (!empty($this->stack)) {
           $parent = array_pop($this->stack);
           $parentId = $parent['id'];
           $this->stack[] = $parent;
        }
        
        // We keep a stack of complex values (i.e. arrays and objects) as we build them,
        // tagged with the type that they are so we know how to add new values.
        $currentItem = [
           'type' => $type,
           'value' => [], 
           'count' => 0,
           'id' => $this->createObjectId($parentId, $type)
        ];
        
        $this->stack[] = $currentItem;
        
       
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
    protected function insertValue($value, $idValue): void
    {
         
        // Grab the top item from the stack that we're currently parsing.
        $currentItem = array_pop($this->stack);

        // Examine the current item, and then:
        //   - if it's an object, associate the newly-parsed value with the most recent key
        //   - if it's an array, push the newly-parsed value to the array

        $index = $currentItem['count']++;
        $key = null;
        
        if ('object' === $currentItem['type']) {
            $key = array_pop($this->keys);
        }

        $this->createValueId($currentItem["id"], $index,  $key, $value, $idValue);
        
        $this->stack[] = $currentItem;

    }
    
    protected function createObject($parentId, $type)
    {
        set_time_limit(30);
   
        $statement = $this->connection->prepare(
              "CALL createObject(?, ?, ?);"
           );
          
        $statement->bind_param(
           'iis',
           $_SESSION['userId'],
           $parentId,
           $type
        );
   
        $statement->execute();
   
        $objectId = NULL;
        $statement->bind_result($objectId);
   
        if (!$statement->fetch()) {
           return NULL;
        }
   
        $statement->close();
        
        return $objectId;
    }

    protected function createObjectId($parentId, $type) {
      // $id = ++$this->nextId;
       $id = $this->createObject($parentId, $type);
       $line = 'Create #' . $id . ' ' . $type . ' parent(' . $parentId . ')';
       $this->printLine($line);
       
       $this->nextId = $id;
       
       return $id;
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
    ) : void
    {
       set_time_limit(30);
   
       $valueId = null;
       
        // Echo results for debug
       $line = '#' . $objectId . ': ' .
          nullable($objectIndex) . ', ' .
          nullable($objectKey) . ', ' .
          ($isNull ? 'true' : 'false') . ', ' .
          nullable($stringValue) . ', ' .
          nullable($numericValue) . ', ' .
          nullable($boolValue) . ', ' .
          nullable($idValue);
          
        $this->printLine($line);
       
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
        
        $statement->close();        

    }
    protected function createValueId($objectId, $objectIndex, $objectKey, $value, $idValue)  {

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
       
       return $valueId;
    }
    
    public function printLine($line) : void {
       //echo $line . "\r\n";
       //return;
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
   $connection = getConnection();
   
   $listener = new JSONDBListener($connection);
   
   date_default_timezone_set('Australia/Brisbane');
   
   
   //$stream = fopen($testfile, 'r');
   $stream = fopen('php://input', 'r');
   
   echo "⏰ Start " . date('Y-m-d H:i:s') . "\r\n";
   flush();
   
   try {
      $parser = new \JsonStreamingParser\Parser($stream, $listener);
      $parser->parse();
      fclose($stream);
   } catch (Exception $e) {
      fclose($stream);
       throw $e;
   }

  // var_dump($listener->getJson());

   $connection->close();
   
   $listener->sendEnd("⏰ End   " . date('Y-m-d H:i:s'));
   
   
   flush();
 
   
   
?>