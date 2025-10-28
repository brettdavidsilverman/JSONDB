<?php

    require_once '../functions.php';

    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === "POST") {

        handlePost();
    }
    else if ($method === "GET") {
        $q = null;
        if (array_key_exists("q", $_GET))
           $q = $_GET["q"];
           
        if (is_null($q))
            handleGet();
        else
            handleSearch($q);
            
    }
    

 
?>