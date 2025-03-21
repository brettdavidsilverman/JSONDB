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
   
setCredentialsCookie($credentials);

?>