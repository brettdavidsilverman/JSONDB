<?php
   require_once "server/functions.php";
   
   http_response_code(200);
   
   $credentials = getCredentialsCookie();
   
   setCredentialsCookie($credentials);
   
   header("content-type: text/html");

?>
<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <title id="title">bee.fish api</title>
      <script src="https://bee.fish/client/head.js?v=3"></script>      <script src="https://bee.fish/client/authentication/authentication.js?v=34"></script>
      <script src="https://bee.fish/client/authentication/sha512.js"></script>
      <link rel="stylesheet" type="text/css" href="style.css"/>
      <script>

      </script>
   </head>
   <body>
      <h1 id="h1">Status</h1>
      <div id="expires"></div>
      <label for="progress"><div id="progressLabel"></div></label>
      <progress id="progress" value="0" max="100"></progress><div id="sessionKey"></div>

      <script>
var authentication =
   new Authentication("https://bee.fish");
   
var progress = document.getElementById("progress");
var progressLabel = document.getElementById("progressLabel");
var uploading = false;
var origin;

window.onmessage = function(event)
{
    origin = event.origin;
    var data = event.data;
    var command = data.command;
    switch (command)
    {
       case "setCredentials":
          var credentials =
             data.credentials;
            
          authentication.setCredentials(
             credentials
          );
if (credentials)
   document.getElementById("sessionKey").innerText =
      credentials.sessionKey;

          updateStatus();
          
          break;
          
       case "postFile":

          postFile(
             data.path,
             data.file
          );
          break;
       default:
          displayError("Invalid command " + command, "api.onmessage");
    }
    

    
    

}

  
authentication.onHandleLogon =
   () => {};
   

function postFile(path, file) {
   updateStatus(
      {
         label: "Uploading...",
         percentage: 1,
         done: false,
         error: false
      }
   );
      //const file = event.target.files[0];
    
   authentication.setSessionStatus(
      "Uploading...",
      2,
      false
   )
   .then(
      (ok) => {
         return authentication.postFile(
            path,
            file
         );
      }
   )
   .catch(
      (error) => {
         displayError(error, postFile);
      }
   );
}
   
   //alert(self.crypto.randomUUID());
function displayExpires() {
   var div = document.getElementById("expires");
   
   var credentials =
      authentication.getCredentials();
      
   if (credentials) {
      var expires = credentials.expires;
      div.innerText = new Date(expires);
   }
   else
      div.innerText = "No credentials";
   
 
}

function updateStatus(status) {
    
   displayExpires();

   if (!status && authentication.authenticated) {
      authentication
      .getSessionStatus()
      .then(
         (status) => {
            updateStatus(status);
         }
      )
      .catch(
         (error) => {
            window.clearInterval(intervalId);
            displayError(error, updateStatus);
         }
      );
      return;
   }
   
   try {
      progress.value = 0;
      progressLabel.innerText = "";
   
      if (!status)
         return;

      window.parent.postMessage(
         status,
         origin
      );
   
      progress.value = status.percentage;
      progressLabel.innerText = status.label;
   }
   catch (error) {
      window.clearInterval(intervalId);
      displayError(error, updateStatus);
   }
   
}
      
var intervalId =
   window.setInterval(
      function() {
         updateStatus();
      },
      1000 * 5
   );
      
updateStatus();
        </script>

   </body>

</html>