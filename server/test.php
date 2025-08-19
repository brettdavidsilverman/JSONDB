<?php

    require_once "functions.php";
    $credentials = authenticate();
    
    http_response_code(200);
    
    setCredentialsCookie($credentials);
    header("Content-Type: application/json");
    
    $result = writeToDatabase(
        $credentials,
        "/my",
        null
    );

    echo encodeString($result);
/*
    $listener1 = new JSONDBListener(
        null, //$connection,
        $credentials,
        "/my/one", //$path,
        "one", //$object,
        null, //$stream,
        null, //$jobPath
    );
    
    $listener2 = new JSONDBListener(
        null, //$connection,
        $credentials,
        "/my/two", //$path,
        "two", //$object,
        null, //$stream,
        null, //$jobPath
    );

    $valueId1 = $listener1->getPathValueId();
    $valueId2 = $listener2->getPathValueId();
echo json_encode([$valueId1, $valueId2]);
*/

try {
    $connection = getConnection();
    $connection->begin_transaction();
    $result = writeToDatabaseEx(
        $connection,
        $credentials,
        "/my/one", //$path,
        "Hello world", //$object
        null, //$stream
        $listener,
        null, "/my/jobs/[]" //$jobPath
    );

    writeToDatabase(
        $credentials,
        "/my/two",
        "💕"
    );

    $connection->commit();

  
    echo encodeString($result);

    
}
catch (Exception $ex) {
    $connection->rollback();
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