<?php

require_once __DIR__ . "/../functions.php";

session_start(
   [
      'cookie_lifetime' => 1800
   ]
);


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
      $sessionId,
      $expiryDate
   );
   
   if (!$statement->fetch())
      $sessionId = NULL;
      
   $statement->close();
   
   if (!is_null($sessionId))
   {
    
      $credentials = array(
         "userId" => $userId, 
         "expiryDate" => $expiryDate,
         "authenticated" => true
      );
      
      $_SESSION["sessionId"] = $sessionId;
      
   }
   else
   {
      $credentials = null;
      session_unset();
   }
   
   return $credentials;
}

function logoff($connection, $ipAddress)
{
   $statement = $connection->prepare(
     "CALL logoff(?, ?);"
   );
   
   if (array_key_exists("sessionId", $_SESSION))
   {
      $statement->bind_param(
         'ss',
         $_SESSION["sessionId"],
         $ipAddress
      );
   
      $statement->execute();

   }
   
   setCredentialsCookie(null);
   
   session_unset();
 
   
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
   $expiryTime = null;
   
   if (!is_null($credentials)) {

      $expiryTime =
         strtotime($credentials['expiryDate']);
      
   }
   else {
      $credentials = array(
         "authenticated" => false
      );
     
   }
   
   if (is_null($expiryTime))
      $expiryTime = time();
   
   setcookie(
      "credentials",
      json_encode($credentials),
      $expiryTime,
      "/"
   );
}


function _authenticate($connection)
{
 
   $statement = $connection->prepare(
     'CALL authenticate(?, ?);'
   );
   
   $statement->bind_param(
      'ss',
      $_SESSION["sessionId"],
      $_SERVER['REMOTE_ADDR']
   );
   
   $statement->execute();

   $statement->bind_result(
      $sessionId,
      $userId,
      $expiryDate
   );
   

   if ($statement->fetch()) {
      $credentials = array(
         "userId" => $userId, 
         "expiryDate" => $expiryDate,
         "authenticated" => true
      );
      $_SESSION["sessionId"] = $sessionId;
      $_SESSION["userId"] = $userId;
   }
   else {
      $credentials = null;
      session_unset();
   }
      
   $statement->close();
   
   return $credentials;
}


function authenticate()
{
   $connection = getConnection();
   
   $credentials = _authenticate(
      $connection
   );
      
   $connection->close();
   
   setCredentialsCookie($credentials);
   
   if (is_null($credentials)) {
      $url = '/client/authentication/logon.php';
      $redirect = $_SERVER['REQUEST_URI'];
      $url = $url . '?redirect=' . urlencode($redirect);
      redirect($url);
   }
   else
      return true;
}



?>