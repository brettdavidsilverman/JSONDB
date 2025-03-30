<?php
   declare(strict_types=1);
   require_once '../functions.php';
   require_once '../authentication/functions.php';
   require_once 'functions.php';
   require_once 'JSONDBListener.php';
   
   authenticate();
   
   
   //header('Content-Encoding: gzip');
   //echo "URI❤️\t" . $_SERVER['REQUEST_URI'] . "\r\n";
   //echo "Query💜\t" . $_SERVER['QUERY_STRING'] . "\r\n";
   
   
   $testfile = __DIR__.'/jsonstreamingparser/tests/data/example.json';
   $testfile = __DIR__.'/../../tests/test.json';
   $testfile = __DIR__.'/../../tests/large.json';
   

   $connection = getConnection();
   
   date_default_timezone_set('Australia/Brisbane');
   
   $method = $_SERVER['REQUEST_METHOD'];

   if ($method === "POST")
      handlePost($connection);
   else if ($method === "GET")
      handleGet($connection);
      
   $connection->close();
      flush();

 
   function handlePost($connection)
   {
      
      //$stream = fopen($testfile, 'r');
      $stream = fopen('php://input', 'r');
   
      $start = "⏰ Start " . date('Y-m-d H:i:s') . "\r\n";

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
      header('Content-Type: text/plain');

      echo $start .
          "⏰ End   " . date("Y-m-d H:i:s") . "\r\n";
         
   }
   
   function handleGet($connection)
   {
      
      $objectId = null;
      $valueId = null;
      $rootObjectId = getRootObjectId($connection);
      
      $path = getPath();
      $paths = explode("/", $path);
      

      if (count($paths) > 1) {
         $valueId = getValueByPath($connection, $rootObjectId, $paths);

         if (is_null($valueId)) {
            http_response_code(404);
            header('Content-Type: text/plain');
            echo "Path " . join("/", $paths) . " not found\r\n";
            exit();
         }
         $objectId = null;
      }
      else
         $objectId = $rootObjectId;
      
      header('Content-Type: application/json');
      
      $statement = $connection->prepare(
          "CALL getObjectValues(?, ?);"
      );



      printValues($statement, $objectId, $valueId);
      
      
   }
   
   function printValues(& $statement, $objectId, $valueId) {

      $statement->bind_param(
         'ii', 
         $objectId,
         $valueId
      );
      
      $statement->execute();
      
      $values = loadObjectValues($statement);
      $objectType = $values[0]["type"];
      $trailer = null;
      if (is_null($valueId))
      {
         if ($objectType === 'object') {
            echo "{";
            $trailer = "}";
         }
         else if ($objectType === 'array') {
            echo "[";
            $trailer = "]";
         }
      }
        
      foreach ($values as $value)
      {
         
         $objectId = $value['objectId'];
         $type = $value['type'];
         $objectKey = $value['objectKey'];
         $objectIndex = $value['objectIndex'];
         $isNull = $value['isNull'];
         $numericValue = $value['numericValue'];
         $stringValue = $value['stringValue'];
         $boolValue = $value['boolValue'];
         $idValue = $value['idValue'];
         $isLast = $value['isLast'];
         

         
            // Write object or array header
        //
         if (is_null($objectIndex))
            $objectIndex = 0;
            
         
         if ($objectIndex > 0 && is_null($valueId))
            echo ', ';
               
            
         if ($type === 'object' &&
            !is_null($objectKey) && is_null($valueId))
         {
            echo encodeString($objectKey) . ': ';
         }
      
         
         // Write value
            
         if ($isNull)
            echo 'null';
         else if (!is_null($numericValue))
            echo $numericValue;
         else if (!is_null($stringValue))
             echo encodeString($stringValue);
         else if (!is_null($boolValue)) {
             if ($boolValue)
                echo 'true';
             else
                 echo 'false';
         }
         else if (!is_null($idValue)) {
            printValues($statement, $idValue, null);

         }
         
         
      }
      
      if ($trailer)
         echo $trailer;
  }
  
  function loadObjectValues(& $statement) {
     $values = [];
    
     $result = $statement->get_result();
    
     while ($row = $result->fetch_assoc()) {
        $values[] = $row;
     }
    
     return $values;
 }

   
?>