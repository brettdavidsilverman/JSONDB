<?php
require_once 'connection.php';
require_once 'credentials.php';

function logoff($connection, $sessionId, $ipAddress)
{
   $statement = $connection->prepare(
     "CALL logoff(?, ?);"
   );
   
   $statement->bind_param(
      'ss',
      $sessionId,
      $ipAddress
   );
   
   $statement->execute();

   $statement->close();
   
}

$connection = getConnection();

if (array_key_exists('credentials', $_COOKIE)) {
    
   $cookie = $_COOKIE['credentials'];
   $credentials = json_decode($cookie, true);
   if (array_key_exists("sessionId", $credentials)) {
      $sessionId = $credentials['sessionId'];
      $ipAddress = $_SERVER['REMOTE_ADDR'];
      logoff(
         $connection,
         $sessionId,
         $ipAddress
      );
   }
}

$connection->close();
   
setCredentialsCookie(NULL);



?>