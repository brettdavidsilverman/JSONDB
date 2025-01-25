<?php
function setCredentialsCookie($credentials)
{
   $headers = apache_request_headers();
   $host = $headers['Host'];
   $expiryTime = null;
   
   if (!is_null($credentials)) {

      if (array_key_exists('expiryDate', $credentials)) {
         $expiryTime =
            strtotime($credentials['expiryDate']);
      }
      
   }
   else {
      $credentials = array(
         "authenticated" => false
      );
     
   }
   
   if (is_null($expiryTime))
      $expiryTime = time() + 3600;
   
   setcookie(
      "credentials",
      json_encode($credentials),
      $expiryTime,
      "/",
      $host,
      true
   );
 
   
  // echo json_encode($credentials);
}

?>