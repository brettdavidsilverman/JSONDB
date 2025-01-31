<?php
require_once 'functions.php';

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