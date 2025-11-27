<?php

    require_once '../functions.php';
    
    $connection = getConnection();
    
    $credentials = authenticate();
    
    http_response_code(200);
    header("content-type: application/json");
    
    setCredentialsCookie($credentials);
    
    $path = getQuery();
    
    $valueId = getValueIdByPath(
        $connection, 
        $credentials,
        $path
    );
    
    $connection->close();
    
    $result = [
       "path" => $path,
       "valueId" => $valueId
    ];
    
    echo json_encode($result);

?>