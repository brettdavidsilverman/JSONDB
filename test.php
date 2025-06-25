<?php

    require_once "server/functions.php";
    $credentials = authenticate();
    
    http_response_code(200);
    
    setCredentialsCookie($credentials);
    header("Content-Type: text/plain");
/*
    $jobPath = writeToDatabase(
        $credentials,
        "/my/jobs/[]",
        [
            "label" => "Indexing..."
        ]
    );
    */
    $object = readFromDatabase(
        $credentials,
        "/my/hello"
    );
    
    var_dump($object);
    
    
    //echo $pathValueId;
?>