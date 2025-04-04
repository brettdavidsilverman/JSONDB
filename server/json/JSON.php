<?php
   declare(strict_types=1);
   require_once '../functions.php';
   require_once '../authentication/functions.php';
   require_once 'functions.php';
   require_once 'JSONDBListener.php';
   
   
   $credentials = authenticate();
   
   http_response_code(200);
   
   setCredentialsCookie($credentials);
   
   $userId = $credentials["userId"];
   
   //header('Content-Encoding: gzip');
   //echo "URI❤️\t" . $_SERVER['REQUEST_URI'] . "\r\n";
   //echo "Query💜\t" . $_SERVER['QUERY_STRING'] . "\r\n";
   
   
   $testfile = __DIR__.'/jsonstreamingparser/tests/data/example.json';
   $testfile = __DIR__.'/../../tests/test.json';
   $testfile = __DIR__.'/../../tests/large.json';
   

   $connection = getConnection();
   
   $method = $_SERVER['REQUEST_METHOD'];

   if ($method === "POST")
      handlePost($connection, $credentials);
   else if ($method === "GET")
      handleGet($connection, $credentials);
      
   $connection->close();
      flush();

 
   function handlePost($connection, $credentials)
   {
      
      //$stream = fopen($testfile, 'r');
      $stream = fopen('php://input', 'r');
   
      $start = "⏰ Start " . date('Y-m-d H:i:s') . "\r\n";

      $listener = new JSONDBListener($connection, $credentials);

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
   
   function handleGet($connection, $credentials)
   {
      $userId = $credentials["userId"];
      $objectId = null;
      $valueId = null;
      $rootObjectId = getRootObjectId($connection, $userId);
      
      $path = getPath();
      $paths = explode("/", $path);
      

      if (count($paths) > 1) {
         $valueId = getValueByPath($connection, $userId, $rootObjectId, $paths);

         if (is_null($valueId)) {
            http_response_code(404);
            header('Content-Type: text/plain');
            echo "🛑 Path " . join("/", $paths) . " not found\r\n";
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
   
   function printValues(& $statement, $objectId, $valueId, $tabCount = -1) {

      $statement->bind_param(
         'ii', 
         $objectId,
         $valueId
      );
      
      $statement->execute();
      
      $values = loadObjectValues($statement);
      
      // Print opening bracket
      // and store the corresponding
      // closure trailer
      $objectType = $values[0]["type"];
      $isEmpty = is_null($values[0]["objectIndex"]);
      $trailer = null;
      
      $isSingleValue = !is_null($valueId);
      
      if (!$isSingleValue)
      {
         //echo tabs($tabCount);
         if ($objectType === 'object') {
            echo "{";
            $trailer = "}";
         }
         else if ($objectType === 'array') {
            echo "[";
            $trailer = "]";
         }
         if (!$isEmpty && $objectType != 'root') {
            echo "\r\n";
            echo tabs($tabCount + 1);
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
         
         if (!$isSingleValue)
         {
           // echo tabs($tabCount + 1);
         }
         
         // Write object key
         if ($type === 'object' &&
            !is_null($objectKey) &&
            !$isSingleValue)
         {
            echo encodeString($objectKey) . 
                 ': ';
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
            // Print this child
            printValues(
               $statement,
               $idValue,
               null,
               $tabCount + 1
            );

         }
         
         // Write array or key seperator
         if (!$isLast &&
             !$isSingleValue)
         {
            echo ",";
            echo "\r\n";
            echo tabs($tabCount + 1);
         }
            
         
      }
      
      // Print final closure
      if ($trailer) {
         if (!$isEmpty) {
            echo "\r\n";
            echo tabs($tabCount);
         }
         echo $trailer;
         
      }
   }
  
   function loadObjectValues(& $statement) {
      $values = [];
    
      $result = $statement->get_result();
    
      while ($row = $result->fetch_assoc()) {
         $values[] = $row;
      }
    
      return $values;
   }

   function tabs($tabCount) {
       return str_repeat("   ", $tabCount);
   }
   
?>