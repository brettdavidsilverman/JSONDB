<?php

require_once "functions.php";

$credentials = authenticate();

$cancelLastUpload =
    getCancelLastUpload($credentials);

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

if ($cancelLastUpload)
   echo "true";
else
   echo "false";

?>