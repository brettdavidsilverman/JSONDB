<?php

    require_once '../functions.php';

    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === "POST") {

        handlePost();
    }
    else if ($method === "GET") {
        $q = getQueryParameter("q");
           
        if (is_null($q))
            handleGet();
        else
            handleSearch($q);
            
    }
    

 
?>