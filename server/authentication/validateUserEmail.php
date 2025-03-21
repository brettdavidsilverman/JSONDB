<?php
   require_once 'functions.php';
   
   $connection = getConnection();

   $email = $_GET['email'];
   $newUserSecret = $_GET['newUserSecret'];
   
   $validated = validateUserEmail(
      $connection,
      $email,
      $newUserSecret
   );
   
   $connection->close();
   
   if ($validated)
      redirect('/');
   else
      http_response_code(500);
?>