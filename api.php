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
      <title id="title"><?php echo getConfig()["Domain"] ?> api></title>
      <script src="/client/head.js?v=3"></script>      <script src="/client/authentication/authentication.js?v=34"></script>
      <script src="/client/authentication/sha512.js"></script>
      <link rel="stylesheet" type="text/css" href="style.css"/>
      <script>

      </script>
   </head>
   <body>
      <h1 id="h1">Status</h1>
      <!--
      <input type="email" id="email"></input>
      <input type="file" onchange="logon(this)"></input>
      <br/>
      -->
      <div id="expires"></div>
      <label for="progress"><div id="progressLabel"></div></label>
      <progress id="progress" value="0" max="100"></progress><div id="sessionKey"></div>

      <script>
var authentication =
   new Authentication("https://<?php echo getConfig()["Domain"] ?>");
   
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
          break;
          
       case "postFile":

          authentication.postFile(
              data.path,
              data.file
          );
          
          break;
          
       case "cancel":
          
          authentication.cancelLastUpload();
          
          break;

       default:
          displayError("Invalid command " + command, "api.onmessage");
    }
    

    displayExpires();
    

}

  
authentication.onHandleLogon =
   () => {};
   



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

authentication.onUpdateStatus =
 function(status) {
    
   displayExpires();

   try {
      progress.value = 0;
      progressLabel.innerText = "";
   
      if (!status)
         return;

      progress.value = status.percentage;
      progressLabel.innerText = status.label;
   }
   catch (error) {
      displayError(error, "onUpdateStatus");
   }
   
}

function logon(fileInput) {
    var email =
       document.getElementById("email").value;
    
    var secret =
        authentication.getFileHash(
            fileInput.files[0]
        );
        
    fileInput.value = null;
    
    secret.then(
        (key) => {
           return authentication.logon(
              email,
              key
           );
        }
    )
    .then(
        (ok) => {
            if (ok)
               alert("Logged on");
            else
               alert("Invalid authentication");
            displayExpires();
        }
    );
    
    
}
      
authentication.updateStatus();
        </script>

   </body>

</html>