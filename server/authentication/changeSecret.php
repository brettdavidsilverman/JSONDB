<?php
require_once 'functions.php';

$connection = getConnection();

$json =
   getPostedData();
   
$email = $json['email'];
$oldSecret = $json['oldSecret'];
$newSecret = $json['newSecret'];

$result =
   changeSecret(
      $connection,
      $email,
      $oldSecret,
      $newSecret
   );
   
$connection->close();
   
if ($result === true)
   echo 'true';
else
   echo 'false';

?>