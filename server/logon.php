<?php
function logon($connection, $email, $secret, $ipAddress)
{
   $statement = $connection->prepare(
     "CALL logon(?, ?, ?);"
   );
   
   $statement->bind_param('sss', $email, $secret, $ipAddress );
   
   $statement->execute();
   $result = $statement->get_result();
   $row = $result->fetch_assoc();
   
   $userId = $row['userId'];
   $sessionId = $row['sessionId'];
   
   $statement->close();
   
   if (is_null($sessionId))
      return NULL;
   else {
      $json = array(
         "userId" => $userId, 
         "sessionId" => $sessionId,
         "authenticated" => true
      );
      return $json;
   }
}

$connection = require('connection.php');

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
   
if (!is_null($credentials)) {
   $output = json_encode($credentials);

   echo $output;
}

$connection->close();
   
?>