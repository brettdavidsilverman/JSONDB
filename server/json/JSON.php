<?php
   declare(strict_types=1);
   require_once '../authentication/functions.php';
   require_once 'functions.php';
   require_once 'JSONDBListener.php';
   
   authenticate();
   
   
   //header('Content-Encoding: gzip');
   //echo "URI❤️\t" . $_SERVER['REQUEST_URI'] . "\r\n";
   //echo "Query💜\t" . $_SERVER['QUERY_STRING'] . "\r\n";
   
   
   
   $testfile = __DIR__.'/jsonstreamingparser/tests/data/example.json';
   $testfile = __DIR__.'/../tests/test.json';
   $testfile = __DIR__.'/../tests/large.json';
   
function escape($value) {
   return $value;
   //return mysql_real_escape_string($value);
}

   

   $connection = getConnection();
   
   date_default_timezone_set('Australia/Brisbane');
   
   $method = $_SERVER['REQUEST_METHOD'];
   
   if ($method === "POST")
   {
      header('Content-Type: text/plain');
      //$stream = fopen($testfile, 'r');
      $stream = fopen('php://input', 'r');
   
      echo "⏰ Start " . date('Y-m-d H:i:s') . "\r\n";
         
      $listener = new JSONDBListener($connection);

      try {
         $parser = new \JsonStreamingParser\Parser($stream, $listener);
         $parser->parse();
         fclose($stream);
      }
      catch (Exception $e) {
         fclose($stream);
         throw $e;
      }
      
      $listener->sendEnd("⏰ End  #" . $listener->rootObjectId . " " . date('Y-m-d H:i:s'));
   
   }
   else if ($method === "GET")
   {
       header('Content-Type: application/json');
       $objectId = getRootObjectId($connection);
       
       echo '{"hello":' . $objectId . '}';
   }

  // var_dump($listener->getJson());

   $connection->close();
   

   
   flush();
 
   
   
?>