<?php
    
    declare(strict_types=1);
    
    require_once '../functions.php';

    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === "POST") {

        handlePost();
    }
    else if ($method === "GET") {
        
        if (getQuery() === "")
            handleGet();
        else
            handleSearch();
            
    }
            flush();

 
?>