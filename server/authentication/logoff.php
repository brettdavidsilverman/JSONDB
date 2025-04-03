<?php
require_once 'functions.php';

$connection = getConnection();
$ipAddress = $_SERVER['REMOTE_ADDR'];

logoff(
   $connection,
   $ipAddress
);

$connection->close();
   
http_response_code(200);

setCredentialsCookie(null);

header("content-type: application/json");

echo 'true';

?>