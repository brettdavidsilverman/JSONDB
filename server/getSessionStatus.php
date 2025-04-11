<?php

require_once "functions.php";

$credentials = authenticate();


$prefix = ini_get("session.upload_progress.prefix");
$name = "postFile";
$key = $prefix . $name;


$progress = null;
if (array_key_exists($key, $_SESSION))
{
    
   $upload = $_SESSION[$key];

   $percentage =
      $upload["bytes_processed"] /
      $upload["content_length"]  *
      100.0;
      
   $error =
      $upload["files"][0]["error"] != 0;
      
   $done  =
      $upload["files"][0]["done"];
      
   $label = null;
   
   if ($error === false) 
      $label = "Uploading...";
   else
      $label = "Error uploading";
       
   if ($done === false)
      $progress = [
         "label" => $label,
         "percentage" => $percentage,
         "done" => false,
         "error" => $error
      ];
   else
      $progress = null;
}

if (is_null($progress))
   $progress = getSessionStatus($credentials);

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

echo json_encode($progress);
   
?>