<?php

   require_once "functions.php";
   
   http_response_code(200);
   
   $connection = getConnection();
   
   header("Content-Type: text/plain");
   
   echo (int)getSetting($connection, "SESSION_TIMEOUT");
   
   $connection->close();
    
?>