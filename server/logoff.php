<?php
require_once 'functions.php';

$connection = getConnection();

if (array_key_exists('credentials', $_COOKIE)) {
    
   $cookie = $_COOKIE['credentials'];
   $credentials = json_decode($cookie, true);
   if (array_key_exists("sessionId", $credentials)) {
      $sessionId = $credentials['sessionId'];
      $ipAddress = $_SERVER['REMOTE_ADDR'];
      logoff(
         $connection,
         $sessionId,
         $ipAddress
      );
   }
}

$connection->close();
   
setCredentialsCookie(NULL);



?>