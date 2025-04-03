<?php
require_once 'functions.php';

$credentials = null;

$json =
   getPostedData();

if (!is_null($json)) {
   $email = $json['email'];
   $secret = $json['secret'];
   $ipAddress = $_SERVER['REMOTE_ADDR'];
   
   $connection = getConnection();

   $credentials =
      logon(
         $connection,
         $email,
         $secret,
         $ipAddress
      );
   
   $connection->close();
}

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

if ($credentials["authenticated"])
   echo "true";
else
   echo "false";// json_encode($credentials);
?>