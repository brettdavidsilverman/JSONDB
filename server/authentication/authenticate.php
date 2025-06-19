<?php

require_once '../functions.php';

$credentials = authenticate();

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

echo json_encode($credentials);

?>