<?php
session_start();

require_once "server/functions.php";
require_once "server/authentication/functions.php";

$credentials = authenticate();

$prefix = ini_get("session.upload_progress.prefix");
$name = "postFile";
$key = $prefix . $name;

http_response_code(200);

header("content-type: application/json");

setCredentialsCookie($credentials);

$progress = null;
if (array_key_exists($key, $_SESSION)) {
    
   $upload = $_SESSION[$key];

   $percentage =
      $upload["bytes_processed"] /
      $upload["content_length"]  *
      100.0;
      
   $error =
      $upload["files"][0]["error"] != 0;
   
   $label = null;
   
   if ($error === false)
      $label = "Uploading...";
   else
      $label = "Error uploading";
   
   $progress = [
      "label" => $label,
      "percentage" => $percentage,
      "done" => $upload["done"],
      "error" => $error
   ];
}
else {
   $progress = null;
}

echo json_encode($progress);

?>