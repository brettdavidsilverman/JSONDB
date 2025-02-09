<?php

function getConnection() {
   $config = file_get_contents('/home/bee/config.json'); 
   $json = json_decode($config);

   $database =     $json->{"Database"};
   $serverName =   $database->{"server"};
   $userName =     $database->{"username"};
   $password =     $database->{"password"};
   $databaseName = $database->{"database"};

   // Create connection
   $connection = new mysqli($serverName, $userName, $password, $databaseName);

   // Check connection
   if ($connection->connect_error) {
     die("Connection failed: " . $connection->connect_error);
   }
   
   return $connection;
}

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

function createUser($connection, $email, $secret)
{
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
         "sessionId" => $sessionId,
         "expiryDate" => $expiryDate,
         "authenticated" => true
      );
      
   }
   else
      $credentials = null;
      
   return $credentials;
}

function logoff($connection, $sessionId, $ipAddress)
{
   $statement = $connection->prepare(
     "CALL logoff(?, ?);"
   );
   
   $statement->bind_param(
      'ss',
      $sessionId,
      $ipAddress
   );
   
   $statement->execute();

   $statement->close();
   
}

function setCredentialsCookie($credentials)
{
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
      "/"
   );
}

function redirect($url)
{
    if (headers_sent() === false)
    {
        header('Location: ' . $url, true, 307);
    }

    exit();
}

function _authenticate($connection, $sessionId, $ipAddress)
{
 
   $statement = $connection->prepare(
     'CALL authenticate(?, ?);'
   );
   
   $statement->bind_param(
      'ss',
      $sessionId,
      $ipAddress
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
         "sessionId" => $sessionId,
         "expiryDate" => $expiryDate,
         "authenticated" => true
      );
   }
   else {
      $credentials = array(
         "authenticated" => false
      );
   }
      
   $statement->close();
   
   return $credentials;
}


function authenticate()
{
   if (array_key_exists('credentials', $_COOKIE)) {
    
      $cookie = $_COOKIE['credentials'];
      $credentials = json_decode($cookie, true);
  
      $ipAddress = $_SERVER['REMOTE_ADDR'];
   
      if (array_key_exists("sessionId", $credentials)) {
       
         $sessionId = $credentials['sessionId'];
      
         $connection = getConnection();
      
         $credentials = _authenticate(
            $connection,
            $sessionId,
            $ipAddress
         );
      
         $connection->close();
      }
      else
         $credentials = null;
   
   }
   else
      $credentials = null;
   
   setCredentialsCookie($credentials);
   
   if (is_null($credentials)) {
      $url = '/logon.php';
      $redirect = $_SERVER['REQUEST_URI'];
      $url = $url . '?redirect=' . urlencode($redirect);
      redirect($url);
   }
   else
      return true;
}


function getPostedData()
{
   $filePointer = fopen('php://input', 'r');

   $input =
      stream_get_contents($filePointer);
      
   fclose($filePointer);
   
   $json =
      json_decode($input, true);
      
   return $json;
}

?>