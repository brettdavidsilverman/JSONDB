<?php

    require_once "server/functions.php";
    
    $credentials = authenticate();
    
    http_response_code(200);
    
    setCredentialsCookie($credentials);
    
    header("Content-Type: text/plain");
    
    $connection = getConnection();
    
    $pathValueId = getValueIdByPath(
        $connection,
        $credentials,
        "/my/data/"
    );
     
    $connection->close();
    
    var_dump($pathValueId);
?>