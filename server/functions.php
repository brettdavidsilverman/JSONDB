<?php

require_once "authentication/functions.php";
require_once "json/functions.php";


function getConfig() {
   static $config = null;
   static $json = null;

   if (is_null($config)) {
       $config = file_get_contents(__DIR__ . '/../../config.json'); 

       $json = json_decode($config, true);
   }

   return $json;
}

function getConnection() {

   static $count = 0;
   $count++;

   $json = getConfig();
 
   $database =     $json["Database"];
   $serverName =   $database["server"];
   $userName =     $database["username"];
   $password =     $database["password"];
   $databaseName = $database["database"];
   
   /* activate reporting */
   $driver = new mysqli_driver();
   $driver->report_mode = 
       MYSQLI_REPORT_ERROR;
   
  // MYSQLI_REPORT_ALL;

   // Create connection
   $connection = new mysqli($serverName, $userName, $password, $databaseName);

   // Check connection
   if ($connection->connect_error) {
     die("Connection failed: " . $connection->connect_error);
   }
/*
   $connection->query(
        "SET " .
        "TRANSACTION ISOLATION LEVEL " .
        "READ COMMITTED"
    );
*/
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

function decodeSlashes($path) {
   // Apache doesnt allow encoded
   // slashes {/}
   // So we double encode them
   // from {%2F} to {%252F}
   // on the client.
   // Here we return the slashes to
   // single encoded {%2F}
   
   // upper case
   $path = str_replace(
       "%252F", "%2F", $path
   );
   
   // lower case
   $path = str_replace(
       "%252f", "%2f", $path
   );
   
   return $path;
   
}

function encodeSlashes($path) {
   // Apache doesnt allow encoded
   // slashes {/}
   // So we double encode them
   // from {%2F} to {%252F}
   // on the client.
   // Here we encode the slashes to
   // double encoded {%252F} to match
   // the client
   
   // upper case
   $path = str_replace(
       "%2F", "%252F", $path
   );
   
   // lower case
   $path = str_replace(
       "%2f", "%252f", $path
   );
   
   return $path;
   
}

function _urldecode($path) {
    $path = rawurldecode($path);
    if (str_starts_with($path, "\"") &&
        str_ends_with($path, "\""))
    {
        return substr($path, 1, -1);
    }
    else if (is_numeric($path))
       return (int)$path;
    else
       return $path;
}

function getPath() {
    
    
   $path = parse_url(
      $_SERVER['REQUEST_URI'],
      PHP_URL_PATH
   );
   
   
   $path = decodeSlashes($path);

   //$path = rawurldecode($path);
   
   // remove trailing slash
   if (str_ends_with($path, "/")) {
      $path = substr($path, 0, -1);
   }

   return $path;
}

function getQuery() {
   $query = $_SERVER['QUERY_STRING'];
   $query = decodeSlashes($query);
   return $query;
}

function getClientIPAddress() {
   $ipAddress = $_SERVER['REMOTE_ADDR'];
   return $ipAddress;
}

function encodeString($string) {

   return
      '"' .
      escapeString(
         $string
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



?>