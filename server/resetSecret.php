<?php
   require_once 'functions.php';
   
   $connection = getConnection();

   $json = getPostedData();
   
   $email = $json['email'];
   $lostSecret = $json['lostSecret'];
   $newSecret = $json['newSecret'];
   
   $success = resetSecret(
      $connection,
      $email,
      $lostSecret,
      $newSecret
   );
   
   $connection->close();
   
   if ($success)
      echo "true";
   else
      echo 'false';
      
?>