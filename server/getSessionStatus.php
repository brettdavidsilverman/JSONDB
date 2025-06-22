<?php

require_once "functions.php";

$credentials = authenticate();

$prefix = ini_get("session.upload_progress.prefix");
$name = "postFile";
$key = $prefix . $name;

$cancelled = getCancelLastUpload($credentials);
$status = null;

if ($cancelled) {
    if (array_key_exists($key, $_SESSION))
        $_SESSION[$key]["cancel_upload"] = true;
    
    $status = [
        "label" => "User cancelled",
        "done" => true
    ];
}
else if (array_key_exists($key, $_SESSION))
{ 
    
    $upload = $_SESSION[$key];

    $percentage =
        $upload["bytes_processed"] /
        $upload["content_length"]  *
        100.0;
      
    $error =
        $upload["files"][0]["error"] != 0;
      
    $done = null;

    $label = null;
   
    if ($cancelled) {
           
        $label = "User cancelled";
        $done = true;
    }
    else if ($error) {
        $label = "Error uploading";
        $done = true;
    }
    else {
        $label = "Uploading...";
        $done = $upload["done"];
    }
       
   
    $status = [
        "label" => $label,
        "percentage" => $percentage,
        "done" => $done,
        "error" => $error
    ];
        

}
else {
    $status = [
        "label" => "Ready",
        "done" => true
    ];
}

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

echo json_encode($status);


?>