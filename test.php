<?php
session_start();

require_once "server/functions.php";
require_once "server/authentication/functions.php";

$credentials = authenticate();

http_response_code(200);

header("content-type: text/html");

setCredentialsCookie($credentials);

?>

<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <title id="title">bee.fish</title>
      <script src="https://bee.fish/client/head.js?v=3"></script>      <script src="https://bee.fish/client/authentication/authentication.js?v=32"></script>
      <script src="https://bee.fish/client/authentication/sha512.js"></script>
      <link rel="stylesheet" type="text/css" href="style.css"/>
      <script>

      </script>
   </head>
   <body>
      <input type="file" id="inputFile" />
      <button id="go">Go</button>
      <br/>
      <label for="progress" id="progressLabel">
      </label>
      <progress id="progress" max="100" value="0"></progress>
      <script>
      
var authentication = new Authentication(
   "https://bee.fish"
);

var go = document.getElementById("go");
var progress = document.getElementById("progress");
var progressLabel = document.getElementById("progressLabel");

go.onclick = postFormData;

function postFormData() {
   go.disabled = true;
   progress.value = 0;
   var inputFile = document.getElementById("inputFile");
   var file = inputFile.files[0];
   authentication.postFile(
      "testupload.php",
      file,
      
      (status) => {
          
         if (status.error) 
            displayError("Error uploading", "postFormData");
            
         progressLabel.innerText =
            status.label;
         progress.value =
            status.percentage;
      }
   )
   .catch(
      (error) => {
         displayError(error, "postFormData");
      }
   )
   .finally(
      () => {
         go.disabled = false;
      }
   );
   
}



</script>