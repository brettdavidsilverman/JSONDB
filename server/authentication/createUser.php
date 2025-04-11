<?php
   require_once '../functions.php';
   
   $connection = getConnection();
   
   $json = getPostedData();
   
   $token = $json['token'];
   $email = $json['email'];
   $secret = $json['secret'];
   
   $newUserSecret = createUser(
      $connection,
      $token,
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
   $subject = 'Validate bee.fish user';

   $secret = urlencode($newUserSecret);
   $email = urlencode($email);
  
   // Message
   $message = "
<html>
<head>
  <title>Validate email</title>
</head>
<body>
  <h1>Validate email</h1>
  <p><a href=\"https://bee.fish/server/authentication/validateUserEmail.php?newUserSecret=$secret&email=$email\">Please validate your email address by clicking this link</a></p>
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