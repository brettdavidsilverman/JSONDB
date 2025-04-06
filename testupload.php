<?php
session_start();
require_once "server/functions.php";
require_once "server/authentication/functions.php";
require_once "server/json/functions.php";

http_response_code(200);

header("content-type: text/plain");

if ($_FILES["file"]["error"] == 0) {
   $file = $_FILES["file"]["tmp_name"];
   $connection = getConnection();
   handlePost($connection, $file);
   $connection->close();
}
else
   echo "false";
?>