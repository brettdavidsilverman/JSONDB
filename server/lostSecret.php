<?php

   require_once 'functions.php';

   $connection = getConnection();
      
   $json = getPostedData();
   
   $email = $json['email'];
   $token = $json['token'];

   $lostSecret = lostSecret(
      $connection,
      $token,
      $email
   );
   
   $connection->close();

   if (is_null($lostSecret)) {
      echo 'false';
      return;
   }
   
   // Multiple recipients
   $to = $email;

   // Subject
   $subject = 'Reset password for bee.fish';

   // Message
   $message = "
<html>
<head>
  <title>Reset password email</title>
</head>
<body>
  <h1>Reset password</h1>
  <p><a href=\"https://bee.fish/logon.php?lostSecret=$lostSecret&email=$email\">Set your password by clicking this link</a></p>
</body>
</html>
";

   // To send HTML mail, the Content-type header must be set
   $headers[] = 'MIME-Version: 1.0';
   $headers[] = 'Content-type: text/html; charset=utf-8';
   $headers[] = 'From: no-reply <noreply.bee.fish@gmail.com>';
   
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