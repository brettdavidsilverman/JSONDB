<?php
require_once 'functions.php';

$connection = getConnection();

$json =
   getPostedData();
   
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
   
http_response_code(200);

setCredentialsCookie($credentials);

//var_dump($credentials);
header("content-type: application/json");

if ($credentials["authenticated"])
   echo "true";
else
   echo "false";// json_encode($credentials);
?>