<?php

    require_once "server/functions.php";
    $credentials = authenticate();
    
    http_response_code(200);
    
    header("Content-Type: text/plain");
    
    $connection = getConnection();
    
    $pathValueId = getValueIdByPath(
        $connection,
        $credentials,
        "/my/data"
    );
     
    $connection->close();
    
    echo $pathValueId;
?>