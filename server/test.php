<?php

    require_once "functions.php";
    $credentials = authenticate();
    
    http_response_code(200);
    
    setCredentialsCookie($credentials);
    header("Content-Type: application/json");
    
        $words = [];
        $delimiter =
            ",“.”\'()*\'\"{}:;!?~`|[] \t\r\n\\";
            
        // tokenize object key
        $token = strtok(
            strtolower("hello to the world"),
            $delimiter
        );
        
        while ($token !== false) {
            $words[] = $token;
            $token = strtok($delimiter);
        }
        
        sort($words);
        
        var_dump($words);
        
        exit();
 
    /*
    $result = writeToDatabase(
        $credentials,
        "/my/jobs",
        json_decode("[]")
    );
    
    $jobPath = writeToDatabase(
        $credentials,
        "/my/jobs/[]",
        json_decode("{}")
    );
    */
    
try {
    $connection = getConnection();
    
    $result = getPathByValueId(
        $connection,
        9179513
    );
    /*
    $result = writeToDatabaseEx(
        $connection,
        $credentials,
        "/my/one", //$path,
        "Hello world", //$object
        null, //$stream
        $listener,
        $jobPath
    );

    writeToDatabase(
        $credentials,
        "/my/one",
        "💕"
    );

*/
  
    echo encodeString($result);

    
}
catch (Exception $ex) {
   # $connection->rollback();
    $error = [
        "label" => $ex->getMessage(),
        "file" => $ex->getFile(),
        "line" => $ex->getLine(),
        "trace" => $ex->getTrace()
    ];
    echo json_encode($error);
}
finally {
    $connection->close();
}


?>