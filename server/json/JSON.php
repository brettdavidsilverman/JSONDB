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
   
      //echo "⏰ Start " . date('Y-m-d H:i:s') . "\r\n";
         
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
      
      $listener->sendEnd("⏰ End  #" . $listener->rootObjectId . " " . date('Y-m-d H:i:s'));
   
   }
   
   function handleGet($connection)
   {
      header('Content-Type: text/plain');
      
      $rootObjectId = getRootObjectId($connection);
      
      $statement = $connection->prepare(
          "CALL getObjectValues(?);"
      );

      $statement->bind_param(
         'i', 
         $objectId
      );
      
      $objectId = $rootObjectId;
      
      $statement->execute();
          /*
      $statement->bind_result(
         $_objectId,
         $parentId,
         $type,
         $ownerId,
         $valueId,
         $objectIndex,
         $objectKey,
         $numericValue,
         $stringValue,
         $idValue,
         $boolValue,
         $isNull
      );
      
            */
      $values = loadObjectValues($statement);
      $trailers = [];
      $first = true;
      while (!empty($values)) {
         $value = array_shift($values);
         
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
         
         if (is_null($objectIndex))
            $objectIndex = 0;
            
         if ($objectIndex === 0)
         {
            if ($type === 'object') {
               echo '{';
               array_unshift($trailers, '}');
            }
            else if ($type === 'array') {
               echo '[';
               array_unshift($trailers, ']');
            }
         }
         else if ($objectIndex > 0)
            echo ',';
               
            
         if ($type === 'object' &&
             !is_null($objectKey))
         {
            echo '"' . escape($objectKey) . '": ';
         }
            
            
         if ($isNull)
            echo 'null';
         else if (!is_null($numericValue))
            echo $numericValue;
         else if (!is_null($stringValue))
            echo '"' . escape($stringValue) . '"';
         else if (!is_null($boolValue)) {
            if ($boolValue)
               echo 'true';
            else
               echo 'false';
         }
         else if (!is_null($idValue)) {
            $objectId = $idValue;
      
            $statement->execute();
                
            $children = loadObjectValues($statement);
            
            $values = array_merge($children, $values);

            continue;

         }
         
         if ($isLast) {
            echo array_shift($trailers);
         }
        
      }
      
      echo join("", $trailers);
   
   }

   function escape($string) {
      return addcslashes(
         $string,
         "\"\f\n\r\t\v\0\\"
      );
   }

   function loadObjectValues($statement) {
      $values = [];
      $objectId;
    
      $result = $statement->get_result();
    
      while ($row = $result->fetch_assoc()) {
         $values[] = $row;
      }
    
      return $values;
   }
?>