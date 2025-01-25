<?php
require_once 'connection.php';
require_once 'credentials.php';

function logon($connection, $email, $secret, $ipAddress)
{
   $statement = $connection->prepare(
     "CALL logon(?, ?, ?);"
   );
   
   $statement->bind_param('sss', $email, $secret, $ipAddress );
   
   $statement->execute();
   
   $statement->bind_result(
      $userId,
      $sessionId,
      $expiryDate
   );
   
   if (!$statement->fetch())
      $sessionId = NULL;
      
   $statement->close();
   
   if (!is_null($sessionId))
   {
      $credentials = array(
         "userId" => $userId, 
         "sessionId" => $sessionId,
         "expiryDate" => $expiryDate,
         "authenticated" => true
      );
      
   }
   else
      $credentials = null;
      
   return $credentials;
}

$connection = getConnection();

$filePointer = fopen('php://input', 'r');

$input =
   stream_get_contents($filePointer);
      
fclose($filePointer);
   
$json =
   json_decode($input, true);
   
$email = $json['email'];
$secret = $json['secret'];
$ipAddress = $_SERVER['REMOTE_ADDR'];
   
$credentials =
   logon(
      $connection,
      $email,
      $secret,
      $ipAddress
   );
   
$connection->close();
   
setCredentialsCookie($credentials);




?>