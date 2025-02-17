<?php
require_once 'functions.php';

$connection = getConnection();
$ipAddress = $_SERVER['REMOTE_ADDR'];

logoff(
   $connection,
   $ipAddress
);

$connection->close();
   
setCredentialsCookie(NULL);



?>