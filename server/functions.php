<?php


function getConfig() {
   $config = file_get_contents('/home/bee/config.json'); 
   $json = json_decode($config);
   return $json;
}

function getConnection() {
   $json = getConfig();
 
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
      $settings->{"reCaptcha"}->{"secretKey"};
   
   
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
        header('Location: ' . $url, true, 307);
    }

    exit();
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

function nullable($value) {
   if (is_null($value))
      return 'null';
   else
      return $value;
}

function getPath() {
   return parse_url(
     $_SERVER['REQUEST_URI'],
     PHP_URL_PATH
   );
}

function getQuery() {
   return $_SERVER['QUERY_STRING'];
}

?>