<?php
require_once '../functions.php';

$connection = getConnection();

logoff($connection);

$connection->close();
   
http_response_code(200);

setCredentialsCookie(null);

header("content-type: application/json");

echo 'true';

?>