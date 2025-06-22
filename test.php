<?php

    require_once "server/functions.php";
    
    $credentials = authenticate();
    
    http_response_code(200);
    
    setCredentialsCookie($credentials);
    
    header("Content-Type: text/plain");

    try {
        writeToDatabase(
            $credentials,
            "/my",
            []
        );
        
        writeToDatabase(
            $credentials,
            "/my/data",
            ["🐝"=>"💕"]
        );

        $connection = getConnection();
        
        readFromDatabaseEx(
            $connection,
            $credentials,
            "/my/data/boo",
            fopen("php://output", "w"),
            false // returnObject
        );
        
        $connection->close();
        
        //var_dump($data);
    }
    catch (Exception $e) {
        var_dump($e);
    }
    
    echo "done";
    
?>
