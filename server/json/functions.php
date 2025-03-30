<?php
require_once __DIR__ . "/../functions.php";

function getRootObjectId($connection)
{
   $path = getPath();
   
   $paths = explode('/', $path);

   $userId = $_SESSION["userId"];
   
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

function getValueByPath($connection, $parentObjectId, & $paths)
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
   
   $userId = $_SESSION['userId'];
   
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
         $paths[$count] = "🛑{" . $path . "}";
         $objectId = null;
         $valueId = null;
         break;
      }
         
      $parentObjectId = $objectId;
   }
   
   $statement->close();
   
   
   
   return $valueId;
}

function encodeString($string) {
   //return json_encode($string);
      
   return
      '"' .
      addcslashes(
         $string,
         "\"\f\n\r\t\v\0\\"
      ) .
      '"';
}
   
?>