<?php

require_once 'functions.php';

$connection = getConnection();

$credentials = getCredentials($connection);

$status = getSessionStatus($connection, $credentials);

$connection->close();

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

if (!is_null($status))
   echo json_encode($status);
else
   echo "null";
   
?>