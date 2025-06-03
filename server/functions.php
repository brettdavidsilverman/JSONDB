<?php

startSession();

require_once "authentication/functions.php";
require_once "json/functions.php";

function getConfig() {
   $config = file_get_contents(__DIR__ . '/../../config.json'); 
   $json = json_decode($config, true);
   return $json;
}

function getConnection() {
   $json = getConfig();
 
   $database =     $json["Database"];
   $serverName =   $database["server"];
   $userName =     $database["username"];
   $password =     $database["password"];
   $databaseName = $database["database"];

   // Create connection
   $connection = new mysqli($serverName, $userName, $password, $databaseName);

   // Check connection
   if ($connection->connect_error) {
     die("Connection failed: " . $connection->connect_error);
   }
   
   return $connection;
}

function getSetting($connection, $settingCode) {
    
   $statement = $connection->prepare(
     'SELECT getSetting(?) as settingValue;'
   );
   
   $statement->bind_param(
      's',
      $settingCode
   );
   
   $settingValue = null;
   
   $statement->execute();

   $statement->bind_result(
      $settingValue
   );
   
   
   if (!$statement->fetch())
      $settingValue = null;
      
   $statement->close();
   
   return $settingValue;
}

function startSession() {
   $connection = getConnection();
   $timeout = (int)getSetting(
      $connection,
      "SESSION_TIMEOUT"
   );

   session_start(
      [
         'cookie_lifetime' => ($timeout - 5),
         'read_and_close' => true
      ]
   );
   
   $connection->close();

}

function encodeQueryString ($data) {
   $req = "";
   foreach ( $data as $key => $value )
             $req .= $key . '=' . urlencode( stripslashes($value) ) . '&';

   // Cut the last '&'
   $req=substr($req,0,strlen($req)-1);
   return $req;
}

function validateReCaptchaToken($token)
{
   $settings = getConfig();

   $secretKey =
      $settings["reCaptcha"]["secretKey"];
   
   
   $data = [
      'secret' => $secretKey,
      'response' => $token,
      'remoteip' =>  $_SERVER['REMOTE_ADDR']
   ];

   // use key 'http' even if you send the request to https://...
   $options = [
      'http' => [
         'header' => "Content-type: application/x-www-form-urlencoded\r\n",
         'method' => 'POST',
         'content' => encodeQueryString($data)
      ]
   ];

   $url = 'https://www.google.com/recaptcha/api/siteverify';
    
   $context = stream_context_create($options);
   $result = file_get_contents($url, false, $context);
   if ($result === false) {
      return false;
   }

   $result = json_decode($result, true);
   
   if ($result["success"] == false)
      return false;


   return true;
   
}

function redirect($url)
{
    if (headers_sent() === false)
    {
        $responseCode =
           http_response_code();
        if ($responseCode === 200)
           $responseCode = 302;
        header('location: ' . $url, true, $responseCode);
    }

    exit();
}

function getPostedData()
{
   $filePointer = fopen('php://input', 'r');

   $input =
      stream_get_contents($filePointer);
      
   fclose($filePointer);
   
   $json = null;
   
   if (!is_null($input))
      $json =
         json_decode($input, true);
      
   return $json;
}

function nullable($value) {
   if (is_null($value))
      return 'null';
   else
      return $value;
}

function getPath() {
   $path = parse_url(
      $_SERVER['REQUEST_URI'],
      PHP_URL_PATH
   );
   /*
   if (substr($path, 0, 1) === "/")
      $path = substr($path, 1);

   if (substr($path, - 1) === "/")
      $path = substr($path, 0, - 1);
*/
   return $path;
}

function getQuery() {
   return $_SERVER['QUERY_STRING'];
}

function getClientIPAddress() {
   $ipAddress = $_SERVER['REMOTE_ADDR'];
   return $ipAddress;
}

function encodeString($string) {

   return
      '"' .
      addcslashes(
         $string,
         "\"\f\n\r\t\v\0\\"
      ) .
      '"';
}

function escapeString($string) {

   return
      addcslashes(
         $string,
         "\"\f\n\r\t\v\0\\"
      );
}
   
function getHeader($name) {
    
   $headers = getallheaders();
   
   if (array_key_exists($name, $headers))
      return $headers[$name];
   
   return null;
   
}

function getSessionStatus($credentials)
{

   if (is_null($credentials) ||
       is_null($credentials["sessionKey"]))
   {
      return null;
   }
   
   $connection = getConnection();
   
   $statement = $connection->prepare(
     'CALL getSessionStatus(?);'
   );
   
   $statement->bind_param(
      's',
      $credentials["sessionKey"]
   );
   
   $status = null;
   
   $statement->execute();

   $statement->bind_result(
      $status
   );
   
   
   if (!$statement->fetch())
      $status = null;
      
   $statement->close();
   
   $connection->close();
  
   if (is_null($status))
      return null;
      
   return json_decode($status, true);
}

function setSessionStatus($credentials, $status)
{
    
   if (is_null($credentials) ||
       is_null($credentials["sessionKey"]))
   {
      return false;
   }
   
   $connection = getConnection();
   
   $statement = $connection->prepare(
     'CALL setSessionStatus(?,?);'
   );
   
   $statement->bind_param(
      'ss',
      $credentials["sessionKey"],
      $statusString
   );
   
   $statusString = json_encode($status);
   
   $statement->execute();

      
   $statement->close();
   
   $connection->close();
  
   return true;
}

function getCancelLastUpload($credentials)
{

   if (is_null($credentials) ||
       is_null($credentials["sessionKey"]))
   {
      return null;
   }
   
   $connection = getConnection();
   
   $statement = $connection->prepare(
     'CALL getCancelLastUpload(?);'
   );
   
   $statement->bind_param(
      's',
      $credentials["sessionKey"]
   );
   
   $cancelLastUpload = null;
   
   $statement->execute();

   $statement->bind_result(
      $cancelLastUpload
   );
   
   
   if (!$statement->fetch())
      $cancelLastUpload = null;
      
   $statement->close();
   
   $connection->close();
  
   if (is_null($cancelLastUpload))
      return null;
      
   return (bool)$cancelLastUpload;
}

function setCancelLastUpload($credentials, $cancelLastUpload)
{
    
   if (is_null($credentials) ||
       is_null($credentials["sessionKey"]))
   {
      return false;
   }
   
   $connection = getConnection();
   
   $statement = $connection->prepare(
     'CALL setCancelLastUpload(?,?);'
   );
   
   $statement->bind_param(
      'si',
      $credentials["sessionKey"],
      $cancelLastUpload
   );
   
   $statement->execute();

      
   $statement->close();
   
   $connection->close();
  
   return true;
}

?>