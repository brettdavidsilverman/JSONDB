<?php
require_once __DIR__ . "/../functions.php";

function getRootObjectId($connection)
{
   $path = getPath();
   
   if (substr($path, 0, 1) === '/')
      $path = substr($path, 1);
      
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

function getValueByPath($connection, $parentObjectId)
{
    
   $statement = $connection->prepare(
     "CALL getValueByPath(?,?,?,?,?);"
   );
   
   $userId = $_SESSION['userId'];
   
   $statement->bind_param(
      'iiiis', 
      $userId,
      $ownerId,
      $parentObjectId,
      $pathIndex,
      $pathKey
   );
   
   $path = getPath();
   
   if (substr($path, 0, 1) === "/")
      $path = substr($path, 1);
      
   $paths = explode('/', $path);
      
   if (empty($paths))
      return null;

   $first = array_shift($paths);
   if ($first === "my")
      $ownerId = $userId;
   else if (is_numeric($first))
      $ownerId = (int)($first);
      
   foreach ($paths as $path) {
       

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
         $objectId = null;
         $valueId = null;
         break;
      }
         
      $parentObjectId = $objectId;
   }
   
   $statement->close();
   
   
   
   return $valueId;
}


?>