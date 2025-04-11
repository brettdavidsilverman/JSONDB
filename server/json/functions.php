<?php

require_once 'JSONDBListener.php';
require_once 'ValueCountListener.php';

function getRootObjectId($connection, $userId)
{
   $path = getPath();
   
   $paths = explode('/', $path);

   $ownerId = null;
   
   if (!empty($paths))
   {
      if ($paths[0] === 'my')
         $ownerId = $userId;
      else if (is_numeric($paths[0]))
         $ownerId = (int)($paths[0]);
   }
   else
      $ownerId = $userId;
      
   $statement = $connection->prepare(
     "CALL getRootObjectId(?,?);"
   );
   
   $statement->bind_param(
      'ii', 
      $userId,
      $ownerId
   );

   $statement->execute();
   
   $statement->bind_result(
      $objectId
   );
   
   if (!$statement->fetch())
      $objectId = null;

   $statement->close();
   
   
   return $objectId;
}

function getValueByPath($connection, $userId, $parentObjectId, & $paths)
{
    
   $statement = $connection->prepare(
     "CALL getValueByPath(?,?,?,?,?);"
   );
   

   $statement->bind_param(
      'iiiis', 
      $userId,
      $ownerId,
      $parentObjectId,
      $pathIndex,
      $pathKey
   );
   
   //$userId = $_SESSION['userId'];
   
   if (empty($paths))
      return null;

   $first = array_shift($paths);
   if ($first === "my")
      $ownerId = $userId;
   else if (is_numeric($first))
      $ownerId = (int)($first);
    
   $valueId = null;
   $count = 0;
   
   foreach ($paths as $path) {
       
      $count++;
      $path = urldecode($path);
      
      if ($path === "")
         continue;
         
      $valueId = null;
       
      if (is_numeric($path)) {
         $pathIndex = (int)($path);
         $pathKey = null;
      }
      else {
         $pathIndex = null;
         $pathKey = $path;
      }
      
      $statement->execute();
   
      $statement->bind_result(
         $objectId,
         $valueId
      );
   
      if (!$statement->fetch()) {
         array_unshift($paths, $first);
         $paths[$count] = "{" . $path . "}";
         $objectId = null;
         $valueId = null;
         break;
      }
         
      $parentObjectId = $objectId;
   }
   
   $statement->close();
   
   
   
   return $valueId;
}

function handlePost($connection, $file = null)
{

   $start = time();
      
   $credentials = authenticate(true);

   http_response_code(200);
   setCredentialsCookie($credentials);
      
   
   header('Content-Type: application/json');
    
   if (is_null($file))
      $file = 'php://input';
      
   $stream = fopen($file, 'r');
   

   $totalValueCount = null;
     
   setSessionStatus($credentials, "Validating...", 4.0, false);
      
   try {
      $listener = new ValueCountListener();
      $parser = new \JsonStreamingParser\Parser($stream, $listener);
      $parser->parse();
      if (!$listener->getResult())
         throw new Exception(
            "Unexpected end of data"
         );
            
         $totalValueCount =
            $listener->valueCount;
   }
   catch (Exception $e) {
          
      setSessionStatus(
         $credentials,
         $e->getMessage(),
         0,
         true
      );
         
      echo "false";
         
      exit();
         
   }
      
   rewind($stream);
   setSessionStatus(
      $credentials,
      "Indexing...",
       0,
       false
   );
      
   try {
      $listener = new JSONDBListener($connection, $credentials, $totalValueCount);
      $parser = new \JsonStreamingParser\Parser($stream, $listener);
      $parser->parse();
   }
   catch (Exception $e) {
      throw $e;
   }
   finally {
      fclose($stream);
   }
      

   $end = time();
      
   $timeTaken = $end - $start;
      
   setSessionStatus(
      $credentials,
      "⏰ Finished in " . $timeTaken . " seconds",
      0,
      true
   );
      
   echo "true";
         
}
   
function handleGet($connection)
{
   $credentials = authenticate();
   
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
      
   http_response_code(200);
   
   
   header('Content-Type: application/json');
     
   setCredentialsCookie($credentials);

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
      
   $objectType = null;
   $isEmpty = true;
      
   // Print opening bracket
   // and store the corresponding
   // closure trail
   if (array_key_exists(0, $values)) {
      $objectType = $values[0]["type"];
      $isEmpty = is_null($values[0]["objectIndex"]);
   }
      
   $trailer = null;
      
   $isSingleValue = !is_null($valueId);
      
   if (!$isSingleValue)
   {
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
   
function uploadJSONFile() {
   $credentials = getCredentialsCookie();
   if (is_null($credentials) ||
       is_null($credentials["sessionKey"]))
   {
      http_response_code(401);
   }
      
   $stream = fopen('php://input', 'r');
   
   http_response_code(200);
      
   header("content-type: text/plain");
      
   echo $credentials["sessionKey"];
      
}
?>