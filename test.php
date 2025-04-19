<?php

require_once "server/functions.php";

$credentials = authenticate();

http_response_code(200);

header("content-type: text/plain");

setCredentialsCookie($credentials);

   $data = [
      'hello' => "world"
   ];

   $authToken =
      urlencode(json_encode($credentials));
   
   var_dump($authToken);
   
   // POST DATA
   // use key 'http' even if you send the request to https://...
   $options = [
      'http' => [
         'header' => array(
             "Content-Type: application/json; charset=utf-8",
             "x-auth-token: " . $authToken
         ),
         'method' => 'POST',
         'content' => json_encode($data)
      ]
   ];

   $url = 'https://bee.fish/my';
    
   $context = stream_context_create($options);
   var_dump($context);
   $result = file_get_contents($url, false, $context);
   var_dump($result);
   
   // GET DATA
    $options = [
      'http' => [
         'header' => array(
             "x-auth-token: " . $authToken
         ),
         'method' => 'GET'
      ]
   ];

   $url = 'https://bee.fish/my';
    
   $context = stream_context_create($options);
   var_dump($context);
   $result = file_get_contents($url, false, $context);
   var_dump($result);
   

$status = getSessionStatus($credentials);
var_dump($status["label"]);

if (!is_null($status))
   $status = json_encode($status);
else
   $status = "null";
   
echo $status . "\r\n";
/*
$result = setSessionStatus(
    $credentials,
    [
        "label" => "My label",
        "percentage" => 50.0,
        "done" => false
    ]
);

var_dump($result);

$status = getSessionStatus($credentials);

if (!is_null($status))
   $status = json_encode($status);
else
   $status = "null";
   
echo $status . "\r\n";

*/
?>
