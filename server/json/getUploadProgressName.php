<?php
require_once "../functions.php";
require_once "../authentication/functions.php";

http_response_code(200);

$credentials = authenticate();

setCredentialsCookie($credentials);

header("content-type: application/json");

echo json_encode(
    ini_get("session.upload_progress.name")
);
?>