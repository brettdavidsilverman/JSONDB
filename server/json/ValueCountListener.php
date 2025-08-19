<?php
//require_once 'jsonstreamingparser/vendor/autoload.php';
require_once "Parser.php";

class ValueCountListener implements  \JsonStreamingParser\Listener\ListenerInterface
{
    
    public $valueCount = 0;
    public $result;

    public function __construct() {

    }
    
    


    public function startDocument(): void
    {
        $this->valueCount = 0;
        $this->result = false;
        
    }
    
    public function endDocument() : void
    {
       $this->result = true;
    }
    

    public function startObject(): void
    {
         $this->valueCount++;
    }

    public function endObject(): void
    {
    }

    public function startArray(): void
    {
         $this->valueCount++;
    }

    public function endArray(): void
    {
    }

    public function key(string $key): void
    {
        
    }

    public function value($value): void
    {
        $this->valueCount++;
    }
    
    
    
    
    public function whitespace(string $whitespace): void
    {
    }

    
    
}

?>