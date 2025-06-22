<?php
require_once "../functions.php";
require_once "../authentication/functions.php";

http_response_code(200);

$credentials = authenticate();

setCredentialsCookie($credentials);

header("content-type: text/plain");

$maxFilesize =  ini_get("upload_max_filesize");

echo json_encode($maxFilesize);

?>