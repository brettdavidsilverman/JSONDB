<?php

    require_once "server/functions.php";
    
    $credentials = authenticate();
    
    http_response_code(200);
    
    setCredentialsCookie($credentials);
    
    header("Content-Type: text/html");
    
    $connection = getConnection();
    
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title id="title"><?php echo getConfig()["Domain"] ?></title>
        <script src="/client/head.js?v=1"></script>
        <script src="/client/stream/stream.js"></script>
        <script src="/client/power-encoding/power-encoding.js"></script>
        <script src="/client/id/id.js"></script>
        <script src="/client/evaluate.js?v=1"></script>        <script src="/client/authentication/authentication.js?v=28"></script>
        <script src="/client/punycode.js"></script>
        <link rel="stylesheet" type="text/css" href="style.css"/>
        <style>
        </style>
    </head>
    <body>
        <h1 id="h1"><?php echo getConfig()["Domain"] ?></h1>
    </body>
</html>