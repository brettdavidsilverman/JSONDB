<?php
require_once '../functions.php';

$credentials = null;

$json =
   getPostedData();

if (!is_null($json)) {
   $email = $json['email'];
   $secret = $json['secret'];
   
   
   $connection = getConnection();

   $credentials =
      logon(
         $connection,
         $email,
         $secret
      );
   
   $connection->close();
}

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

if (!is_null($credentials) &&
    $credentials["authenticated"] == true)
    echo json_encode($credentials);
else
    echo "false";
    

?>