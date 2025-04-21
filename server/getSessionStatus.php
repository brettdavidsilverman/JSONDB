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
        "percentage" => 0,
        "done" => true
    ];
}
else {
    $status = getSessionStatus($credentials);

    if ( !is_null($status) &&
        array_key_exists("label", $status) &&
        ($status["label"] === "Uploading...") &&
        array_key_exists($key, $_SESSION))
    { 
    
        $upload = $_SESSION[$key];

        $percentage =
            $upload["bytes_processed"] /
            $upload["content_length"]  *
            100.0;
      
        $error =
            $upload["files"][0]["error"] != 0;
      
        $done = null;
   
        if ($upload["done"] || $error) //||
        //   $upload["files"][0]["done"])
        {

            $done = true;
        }
        else
            $done = false;
      

        $label = null;
   
        if ($error === false) 
            $label = "Uploading...";
        else
            $label = "Error uploading";
       
   
        if (!$done)
            $status = [
                "label" => $label,
                "percentage" => $percentage,
                "done" => $done,
                "error" => $error
            ];
    }
}

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

echo json_encode($status);


?>