<?php
//require_once 'jsonstreamingparser/vendor/autoload.php';
require_once "Parser.php";

class ValueCountListener implements  \JsonStreamingParser\Listener\ListenerInterface
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
    
    public $valueCount = 0;

    public function __construct() {

    }
    
    

    public function getResult()
    {
        return $this->result;
    }

    public function startDocument(): void
    {
        $this->stack = [];
        $this->keys = [];
        $this->result = false;
        
    }
    
    public function endDocument() : void
    {
       $this->result = true;
    }
    

    public function startObject(): void
    {
    }

    public function endObject(): void
    {
    }

    public function startArray(): void
    {
    }

    public function endArray(): void
    {
    }

    public function key(string $key): void
    {
        $this->keys[] = $key;
        
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