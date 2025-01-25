<?php

require_once 'connection.php';
require_once 'credentials.php';

function authenticate($connection, $sessionId, $ipAddress)
{
 
   $statement = $connection->prepare(
     'CALL authenticate(?, ?);'
   );
   
   $statement->bind_param(
      'ss',
      $sessionId,
      $ipAddress
   );
   
   $statement->execute();

   $statement->bind_result(
      $sessionId,
      $userId,
      $expiryDate
   );
   

   if ($statement->fetch()) {
      $credentials = array(
         "userId" => $userId, 
         "sessionId" => $sessionId,
         "expiryDate" => $expiryDate,
         "authenticated" => true
      );
   }
   else {
      $credentials = array(
         "authenticated" => false
      );
   }
      
   $statement->close();
   
   return $credentials;
}

$connection = getConnection();


if (array_key_exists('credentials', $_COOKIE)) {
    
   $cookie = $_COOKIE['credentials'];
   $credentials = json_decode($cookie, true);
  
   $ipAddress = $_SERVER['REMOTE_ADDR'];
   
   if (array_key_exists("sessionId", $credentials)) {
      $sessionId = $credentials['sessionId'];
      
      $credentials = authenticate(
         $connection,
         $sessionId,
         $ipAddress
      );
      
   }
   else
      $credentials = null;
   
}
else
   $credentials = null;
   
setCredentialsCookie($credentials);

$connection->close();

?>