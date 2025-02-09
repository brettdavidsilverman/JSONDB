<?php
   require_once 'server/functions.php';
   
   $connection = getConnection();
   
   $newUserSecret = createUser($connection, 'bee15@bee.com');
   
   if ($newUserSecret == false)
      echo 'Email already exists';
   else
      echo $newUserSecret;
      
   $connection->close();
?>