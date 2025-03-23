<?php

function getRootObjectId($connection)
{
   $statement = $connection->prepare(
     "CALL getRootObjectId(?);"
   );
   
   $statement->bind_param(
      'i', 
      $_SESSION['userId']
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


?>