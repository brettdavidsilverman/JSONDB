<?php
   declare(strict_types=1);
   require_once 'functions.php';
   
   authenticate();
   
   header('content-type: text/plain;');
   echo "URI❤️\t" . $_SERVER['REQUEST_URI'] . "\r\n";
   echo "Query💜\t" . $_SERVER['QUERY_STRING'] . "\r\n";
   
   
   
   require_once 'jsonstreamingparser/vendor/autoload.php';

   $testfile = __DIR__.'/jsonstreamingparser/tests/data/example.json';
   $testfile = __DIR__.'/../tests/test.json';
   
function escape($value) {
   return $value;
   //return mysql_real_escape_string($value);
}

   
class MyListener extends \JsonStreamingParser\Listener\IdleListener
{
    protected $nextId = 0;
    
    protected $result;

    /**
     * @var array
     */
    protected $stack;
 
 
    /**
     * @var string[]
     */
    protected $keys;

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
    
    
    protected function nextId($type, $parentId) {
       static $id = 0;
       echo 'Create ' . $type . ' parent(' . $parentId . ') #' . ++$id . "\r\n";
       return $id;
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
           'id' => $this->nextId($type, $parentId)
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
    protected function insertValue($value, $id): void
    {
         
        // Grab the top item from the stack that we're currently parsing.
        $currentItem = array_pop($this->stack);

        // Examine the current item, and then:
        //   - if it's an object, associate the newly-parsed value with the most recent key
        //   - if it's an array, push the newly-parsed value to the array

        if ('object' === $currentItem['type']) {
            $key = array_pop($this->keys);
            //$currentItem['value'][$key] = $value;
            echo $currentItem['id'] . ":" . '"' . escape($key) . '"' . ":";
        }
        else {
            $index = $currentItem['count']++;
            //$index = count($currentItem['value']);
            echo $currentItem['id'] . "[" . $index . "] = ";
            
            //$currentItem['value'][] = $value;
        }

        if (is_null($value))
           echo 'null';
        else if (is_numeric($value))
           echo $value;
        else if (is_string($value))
           echo '"' . escape($value) . '"';
        else if (is_bool($value)) {
           if ($value)
              echo 'true';
           else
              echo 'false';
        }
        else if (is_array($value))
           echo '#' . $id;
           
        echo "\r\n";
        
        $this->stack[] = $currentItem;

    }
}

   $listener = new MyListener();
   
   $stream = fopen($testfile, 'r');
   try {
      $parser = new \JsonStreamingParser\Parser($stream, $listener);
      $parser->parse();
      fclose($stream);
   } catch (Exception $e) {
      fclose($stream);
       throw $e;
   }

   var_dump($listener->getJson());


?>