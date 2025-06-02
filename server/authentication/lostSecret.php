<?php

   require_once '../functions.php';
   
   $config = getConfig();
   $domain = $config["Domain"];
   $serverEmail = $config["Server Email"];
   
   $connection = getConnection();
      
   $json = getPostedData();
   
   $token = $json['token'];
   $email = $json['email'];
  
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
   $subject = "Reset password for $domain";

   // Message
   $message = "
<html>
<head>
  <title>Reset password email</title>
</head>
<body>
  <h1>Reset password</h1>
  <p><a href=\"https://$domain/client/authentication/resetSecret.php?lostSecret=" . urlencode($lostSecret) . "&email=" . urlencode($email) . "\">Reset your password by clicking this link</a></p>
</body>
</html>
";

   // To send HTML mail, the Content-type header must be set
   $headers[] = 'MIME-Version: 1.0';
   $headers[] = 'Content-type: text/html; charset=utf-8';
   $headers[] = "From: $domain <$serverEmail>";
   
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