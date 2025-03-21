<?php
require_once 'functions.php';

$connection = getConnection();

$json =
   getPostedData();
   
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