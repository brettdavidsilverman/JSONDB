<?php

require_once "functions.php";

$data = getPostedData();

$credentials = authenticate();

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

if (is_null($data) ||
    !array_key_exists("label", $data) ||
    !array_key_exists("percentage", $data) ||
    !array_key_exists("done", $data))
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