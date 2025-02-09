<?php
require_once 'functions.php';

$connection = getConnection();

$filePointer = fopen('php://input', 'r');

$input =
   stream_get_contents($filePointer);
      
fclose($filePointer);
   
$json =
   json_decode($input, true);
   
$email = $json;
   
$userEmailExists =
   userEmailExists(
      $connection,
      $email
   );
   
$connection->close();

if ($userEmailExists)
   echo 'true';
else
   echo 'false';


?>