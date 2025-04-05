<?php

require_once 'functions.php';

$data = getPostedData();

http_response_code(200);

header("content-type: application/json");

if (is_null($data)) {
   echo "false";
   exit();
}

$credentials = authenticate();

$result = setSessionStatus(
   $credentials,
   $data["label"],
   $data["percentage"],
   $data["done"]
);



http_response_code(200);

setCredentialsCookie($credentials);

if ($result === true)
   echo "true";
else
   echo "false";
   
?>