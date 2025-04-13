<?php

require_once "functions.php";

$credentials = authenticate();

$data = getPostedData();

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

if (is_null($data))
{
   echo "false";
   exit();
}

$result = setSessionStatus(
   $credentials,
   $data["label"],
   $data["percentage"],
   $data["done"]
);


if ($result === true)
   echo "true";
else
   echo "false";
   
?>