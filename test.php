<?php
    session_start();

    require_once "server/functions.php";
    
    $credentials = authenticate();
    
    http_response_code(200);
    
    setCredentialsCookie($credentials);
    header("Content-Type: text/plain");

    var_dump(getHeader("origin"));
    

?>