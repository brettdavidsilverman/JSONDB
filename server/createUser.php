<?php
   require_once 'functions.php';
   
   $connection = getConnection();
   
   $json = getPostedData();
   
   $email = $json['email'];
   $secret = $json['secret'];
   
   $newUserSecret = createUser(
      $connection,
      $email,
      $secret
   );
   
   $connection->close();
   
   if (is_null($newUserSecret)) {
      echo 'false';
      return;
   }
   
   // Multiple recipients
   $to = $email;

   // Subject
   $subject = 'Validate email address from bee.fish';

   // Message
   $message = "
<html>
<head>
  <title>Validate email</title>
</head>
<body>
  <h1>Validate email</h1>
  <p><a href=\"https://bee.fish/server/validateUserEmail.php?newUserSecret=$newUserSecret&email=$email\">Please validate your email address by clicking this link</a></p>
</body>
</html>
";

   // To send HTML mail, the Content-type header must be set
   $headers[] = 'MIME-Version: 1.0';
   $headers[] = 'Content-type: text/html; charset=utf-8';
   $headers[] = 'From: no-reply <brettdavidsilverman@gmail.com>';
   
   // Mail it
   if (mail(
          $to, 
          $subject,
          $message,
          implode("\r\n", $headers)
       ))
      echo 'true';
   else
      echo 'false';
?>