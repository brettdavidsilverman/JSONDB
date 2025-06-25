<?php

    require_once "server/functions.php";
    $credentials = authenticate();
    
    http_response_code(200);
    
    setCredentialsCookie($credentials);
    header("Content-Type: text/plain");
    
    $connection = getConnection();
    $stream = fopen("php://output", "w"),
    /*
    $pathValueId = getValueIdByPath(
        $connection,
        $credentials,
        "/my/data"
    );
     */
    readFromDatabaseEx(
        $connection,
        $credentials,
        "/my/test",
        $stream,
        false // returnObject
    );
    
    $connection->close();
    
    //echo $pathValueId;
?>