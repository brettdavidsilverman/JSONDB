<?php

    require_once '../functions.php';
    
    $credentials = authenticate();
    
    http_response_code(200);
    
    setCredentialsCookie($credentials);
    
    
    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === "POST") {

        handlePost($credentials);
    }
    else if ($method === "GET") {

        $query = getQuery();

        if (is_null($query))
            handleGet($credentials);
        else {
            $q = getQueryParameter("q");
            if (is_null($q))
                $q = $query;
            handleSearch($credentials, $q);
        }
            
    }
    

 
?>