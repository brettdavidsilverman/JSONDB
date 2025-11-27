<?php
session_start();

require_once "../functions.php";

$credentials = authenticate();
http_response_code(200);
setCredentialsCookie($credentials);

header("content-type: application/json");

$prefix = ini_get("session.upload_progress.prefix");

foreach($_SESSION as $key => $value) {

    if (str_starts_with($key, $prefix)) {
        $jobPath = substr($key, strlen($prefix));

        
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
            
            $_SESSION[$key]["cancel_upload"]
                = true;
            session_commit(); 
            
            
            $jobStatus["label"] = "Cancelling";
            $jobStatus["jobPath"] = $jobPath;
            //unset($jobStatus["progress"]);
            
            writeToDatabase(
                $credentials,
                $jobPath,
                $jobStatus
            );
            
            
        }
        
        if ( !is_null($jobStatus) ) {
           
            $upload = $_SESSION[$key];
            
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


}
catch(PathException $ex) {
   # var_dump($ex);
    echo "undefined";
}
finally {
    $connection->close();
}

?>