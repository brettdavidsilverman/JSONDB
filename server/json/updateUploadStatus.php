<?php

require_once "../functions.php";

$credentials = authenticate();

$prefix = ini_get("session.upload_progress.prefix");

http_response_code(200);

setCredentialsCookie($credentials);

header("content-type: application/json");

$uploads = [];

foreach($_SESSION as $key => $value) {
    if (str_starts_with($key, $prefix)) {
        $jobPath = substr($key, strlen($prefix));
        $upload = $_SESSION[$key];

        $jobStatus = readFromDatabase(
            $credentials,
            $jobPath
        );
 
        if ( !is_null($jobStatus) &&
             array_key_exists(
                 "cancel",
                 $jobStatus
             ) &&
             $jobStatus["cancel"] === true
           )
        {

            $upload["cancel_upload"]
                = true;
                
            $jobStatus["label"] = "Cancelling";
            $jobStatus["jobPath"] = $jobPath;
            unset($jobStatus["progress"]);
            
            writeToDatabase(
                $credentials,
                $jobPath,
                $jobStatus
            );
            
        }
        else if ( !is_null($jobStatus) ) {
           

            $progress =
                $upload["bytes_processed"] /
                $upload["content_length"]  *
                100.0;
                

            writeToDatabase(
                $credentials,
                $jobPath . "/progress",
                $progress
            );
            
        }
        
            
    }
}
/*
if (count($uploads) === 0)
   $uploads = null;
   
echo json_encode($uploads);
*/

try {
    $stream = fopen("php://output", "w");
    $connection = getConnection();

    readFromDatabaseEx(
        $connection,
        $credentials,
        "/my/jobs",
        $stream,
        false
    );

    $connection->close();
}
catch(PathException $ex) {
    //var_dump($ex);
    echo "undefined";
}

?>