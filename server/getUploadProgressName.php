<?php
http_response_code(200);

header("content-type: text/plain");

echo ini_get("session.upload_progress.name");
?>