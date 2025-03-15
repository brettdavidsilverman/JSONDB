<?php
   declare(strict_types=1);
   require_once 'functions.php';
   
   //authenticate();
   
   header('Content-Type: text/plain');
   //header('Content-Encoding: gzip');
   http_response_code(200);
   
   //echo "URI❤️\t" . $_SERVER['REQUEST_URI'] . "\r\n";
   //echo "Query💜\t" . $_SERVER['QUERY_STRING'] . "\r\n";
   
   
   
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
    protected $lines;
    protected $pageSize = 80;
    
    public function __construct($connection) {
        
        $this->connection = $connection;
        $this->lines = [];
    }

    public function getJson()
    {
        return $this->result;
    }

    public function startDocument(): void
    {
        $this->stack = [];
        $this->keys = [];
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
           'id' => $this->createId($type, $parentId)
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

        if ('object' === $currentItem['type']) {
            $key = array_pop($this->keys);
            $this->createValue($currentItem["id"], 'object', $key, $value, $idValue);
        }
        else {
            $index = $currentItem['count']++;
            $this->createValue($currentItem["id"], 'array', $index, $value, $idValue);
        }

        $this->stack[] = $currentItem;

    }
    
    protected function createId($type, $parentId) {
       static $id = 0;
       $line = 'Create #' . ++$id . ' ' . $type . ' parent(' . $parentId . ')' . "\r\n";
       $this->printLine($line);
       return $id;
    }
    
    protected function createValue($id, $type, $keyOrIndex, $value, $idValue) : void {
       $line = null;
       if ($type === 'object')
          $line = $id . ":" . '"' . escape($keyOrIndex) . '"' . ": ";
       else
          $line = $id . "[" . $keyOrIndex . "] = ";
          
       $stringVal;
       if (is_null($value))
          $stringVal = 'null';
       else if (is_numeric($value))
          $stringVal = (string)$value;
       else if (is_string($value))
          $stringVal = $value;
       else if (is_bool($value)) {
          if ($value)
             $stringVal = 'true';
          else
             $stringVal = 'false';
       }
       else if (is_array($value))
          $stringVal =  '#' . $idValue;
           
       $line = $line . $stringVal . "\r\n";
       
       $this->printLine($line);
    }
    
    protected function printLine($line) : void {
       $this->lines[] = $line;
       
       $length = count($this->lines);
       
       if ($length > $this->pageSize) {
          echo join("", $this->lines);
          $this->lines = [];
       }
       
       //$this->sendChunk($line);
    }
    
    public function sendEnd() : void {
       
       if (!empty($this->lines)) {
          echo join("", $this->lines);
          $this->lines = [];
       }
       echo "\r\n";
      // echo "0\r\n\r\n";
       //$this->sendChunk('');
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
   
   $stream = fopen($testfile, 'r');
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
   
   $listener->sendEnd();
   
   flush();
 
   
   
?>