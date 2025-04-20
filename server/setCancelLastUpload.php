<?php

require_once "functions.php";


$credentials = authenticate();

$cancelLastUpload = getPostedData();

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

if (is_null($cancelLastUpload))
{
   echo "false";
   exit();
}

$result = setCancelLastUpload(
   $credentials,
   $cancelLastUpload
);


if ($result === true)
   echo "true";
else
   echo "false";
   
?>