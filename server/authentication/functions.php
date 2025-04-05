<?php

require_once __DIR__ . "/../functions.php";
/*
session_start(
   [
      'cookie_lifetime' => 1800
   ]
);

*/

function userEmailExists($connection, $email)
{
   $statement = $connection->prepare(
     "SELECT userEmailExists(?)"
   );
   
   $statement->bind_param('s', $email);
   
   $statement->execute();
   
   $statement->bind_result($exists);
   
   if ($statement->fetch()) {
      $exists = (bool)$exists;
   }
   else {
      $exists = NULL;
   }
   
   $statement->close();
   
   return $exists;
}

function createUser($connection, $token, $email, $secret)
{
   
   if (!validateReCaptchaToken($token))
      return NULL;
      
   $statement = $connection->prepare(
     "CALL createUser(?, ?);"
   );
   
   $statement->bind_param('ss', $email, $secret);
   
   $statement->execute();
   
   $userId = NULL;
   $newUserSecret = NULL;
   
   $statement->bind_result($userId, $newUserSecret);
   
   if (!$statement->fetch()) {
      return NULL;
   }
   
   $statement->close();
   
   return $newUserSecret;
}


function lostSecret($connection, $token, $email)
{
   
   if (!validateReCaptchaToken($token))
      return NULL;
      
   $statement = $connection->prepare(
     "CALL lostSecret(?);"
   );
   
   $statement->bind_param('s', $email);
   
   $statement->execute();
   
   $lostSecret = NULL;
   
   $statement->bind_result($lostSecret);
   
   if (!$statement->fetch()) {
      return NULL;
   }
   
   $statement->close();
   
   return $lostSecret;
}

function resetSecret($connection, $email, $lostSecret, $newSecret)
{
   $statement = $connection->prepare(
     "CALL resetSecret(?,?,?);"
   );
   
   $statement->bind_param('sss', $email, $lostSecret, $newSecret);
   
   $statement->execute();
   
   $success = NULL;
   
   $statement->bind_result($success);
   
   if (!$statement->fetch()) {
      return null;
   }
   
   $statement->close();
  
   return (bool)$success;
}

function validateUserEmail($connection, $email, $newUserSecret)
{
   $statement = $connection->prepare(
     "CALL validateUserEmail(?, ?);"
   );
   
   $statement->bind_param('ss', $email, $newUserSecret);
   
   $statement->execute();
   
   $userValidated = NULL;
   
   $statement->bind_result($userValidated);
   
   if (!$statement->fetch()) {
      return false;
   }
   
   $statement->close();
   
   return $userValidated;
}

function logon($connection, $email, $secret, $ipAddress)
{
   $statement = $connection->prepare(
     "CALL logon(?, ?, ?);"
   );
   
   $statement->bind_param('sss', $email, $secret, $ipAddress );
   
   $statement->execute();
   
   $statement->bind_result(
      $userId,
      $sessionKey,
      $expires
   );
   
   if (!$statement->fetch())
      $sessionKey = NULL;
      
   $statement->close();
   
   if (!is_null($sessionKey))
   {
      $credentials = array(
         "userId" => $userId, 
         "expires" => $expires,
         "authenticated" => true,
         "sessionKey" => $sessionKey
      );
      
   }
   else
   {
      $credentials = getEmptyCredentials();
   }
   
   
   return $credentials;
}

function logoff($connection, $ipAddress)
{
   $statement = $connection->prepare(
     "CALL logoff(?, ?);"
   );
   
   $credentials = getCredentialsCookie();
   
   if (!is_null($credentials) &&
       $credentials["sessionKey"])
   {
      $statement->bind_param(
         'ss',
         $credentials["sessionKey"],
         $ipAddress
      );
   
      $statement->execute();

   }
   

   
 
   
}

function changeSecret($connection, $email, $oldSecret, $newSecret)
{
   $statement = $connection->prepare(
     "CALL changeSecret(?, ?, ?);"
   );
   
   $statement->bind_param('sss', $email, $oldSecret, $newSecret );
   
   $statement->execute();
   
   $statement->bind_result(
      $result
   );
   
   if (!$statement->fetch())
      $result = false;
      
   $statement->close();
   
   
   
   return (bool)$result;
}

function setCredentialsCookie($credentials)
{
    
   if (is_null($credentials)) {

      $credentials = getEmptyCredentials();
     
   }

   $expires = $credentials["expires"];
   
   if (is_null($expires)) {
      // Set expires to 1/2 hour ago
      $expires = time() - 30 * 60;
   }
   else {
      // Convert milliseconds
      // to seconds
      $expires = $expires / 1000;
   }
   
   $credentialsString =
         json_encode($credentials);
      
   setcookie(
      "credentials",
      $credentialsString,
      $expires,
      "/"
   );

   header("x-auth-token: " . urlencode($credentialsString));

}

function getEmptyCredentials()
{
   $credentials = array(
      "userId" => null, 
      "expires" => null,
      "authenticated" => false,
      "sessionKey" => null
   );
   
   return $credentials;
   
}

function getCredentialsCookie()
{
   $headers = getallheaders();
   $credentialsString = null;
   
   if (array_key_exists("x-auth-token", $headers))
   {
      $credentialsString =
         urldecode($headers["x-auth-token"]);
   }
   else if (array_key_exists("credentials", $_COOKIE))
   {
      $credentialsString =
         $_COOKIE['credentials'];
   }

   
   if (!is_null($credentialsString)) {
      $credentials = json_decode(
         $credentialsString,
         true
      );
   
      return $credentials;
   }
   
   $credentials = getEmptyCredentials();
   
   return $credentials;
}


function getCredentials($connection, $ignoreExpires = false)
{
    
   $credentials = getCredentialsCookie();

   if (is_null($credentials) ||
       is_null($credentials["sessionKey"]))
   {
      return getEmptyCredentials();
   }
   
   $statement = $connection->prepare(
     'CALL authenticate(?, ?, ?);'
   );
   
   $statement->bind_param(
      'ssi',
      $credentials["sessionKey"],
      $_SERVER['REMOTE_ADDR'],
      $ignoreExpires
   );
   
   $statement->execute();

   $statement->bind_result(
      $sessionKey,
      $userId,
      $expires
   );
   

   if ($statement->fetch()) {
      $credentials = array(
         "userId" => $userId, 
         "expires" => $expires,
         "authenticated" => true,
         "sessionKey" => $sessionKey
      );
   }
   else {
      $credentials = getEmptyCredentials();
   }
      
   $statement->close();
   
  
   return $credentials;
}


function authenticate($ignoreExpires = false)
{
    
   $connection = getConnection();
   
   $credentials = getCredentials(
      $connection,
      $ignoreExpires
   );

   $connection->close();
   
   $isFetchClient =
       !is_null(
          getHeader("x-auth-token")
       );
       
   if ($credentials["authenticated"] === false) {
       
      http_response_code(401);
      
      if (!$isFetchClient) {
          $url = '/client/authentication/logon.php';
          $redirect = $_SERVER['REQUEST_URI'];
          $url = $url . '?redirect=' . urlencode($redirect);
          redirect($url);
      }
      
      exit();

   }
   
   
   return $credentials;

}


function refresh() {

   $connection = getConnection();
   $credentials = getCredentials($connection);
   $connection->close();

   return $credentials;

}

function getSessionStatus($connection, $credentials)
{

   if (is_null($credentials) ||
       is_null($credentials["sessionKey"]))
   {
      return null;
   }
   
   $statement = $connection->prepare(
     'CALL getSessionStatus(?);'
   );
   
   $statement->bind_param(
      's',
      $credentials["sessionKey"]
   );
   
   $statement->execute();

   $statement->bind_result(
      $label,
      $percentage,
      $done
   );
   
   $status = null;
   
   if ($statement->fetch()) {
      $status =[
         "label" => $label,
         "percentage" => $percentage,
         "done" => $done
      ];
   }
   else {
      $status =[
         "label" => null,
         "percentage" => null
      ];
   }
      
   $statement->close();
   
  
   return $status;
}

function setSessionStatus($credentials, $label, $percentage, $done)
{
    
   if (is_null($credentials) ||
       is_null($credentials["sessionKey"]))
   {
      return false;
   }
   
   $connection = getConnection();
   
   $statement = $connection->prepare(
     'CALL setSessionStatus(?,?,?,?);'
   );
   
   $statement->bind_param(
      'ssdi',
      $credentials["sessionKey"],
      $label,
      $percentage,
      $done
   );
   
   $statement->execute();

      
   $statement->close();
   
   $connection->close();
  
   return true;
}



?>