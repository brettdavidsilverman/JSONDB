<?php

require_once "functions.php";


$credentials = authenticate();

$status = getPostedData();

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

if (is_null($status))
{
   echo "false";
   exit();
}

$result = setSessionStatus(
   $credentials,
   $status
);


if ($result === true)
   echo "true";
else
   echo "false";
   
?>