<?php
session_start();

require_once "functions.php";

$prefix = ini_get("session.upload_progress.prefix");
$name = "postFile";
$key = $prefix . $name;


$credentials = authenticate();

$connection = getConnection();

$progress = null;
if (array_key_exists($key, $_SESSION) &&
   !$_SESSION[$key]["done"]) {
    
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
      "done" => false,
      "error" => $error
   ];
}
else {
   $progress = getSessionStatus($connection, $credentials);

}


$connection->close();

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

echo json_encode($progress);
   
?>