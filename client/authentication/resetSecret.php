<?php
   require_once "../../server/functions.php";
?>
<!DOCTYPE html>
<html lang="en">
   <head>
      <script src="/client/head.js"></script>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <script src="https://www.google.com/recaptcha/api.js"></script>
      <script src="/client/fetch.js"></script>
      <script src="/client/console/console.js"></script>
      <script src="sha512.js"></script>
      <script src="thumbnailSecret.js"></script>
      <script src="authentication.js?v=11"></script>
      <link rel="stylesheet" type="text/css" href="/style.css" />
      <link rel="stylesheet" type="text/css" href="style.css" />
      <title>Reset secret</title>
      <style>

      </style>
   </head>
   <body>
      <h1>Reset secret</h1>
      <p>Please provide your email address and your secret file, then click reset.</p>
      <br/>
      <a href="/client/authentication/authentication.js">authentication.js</a>
           
      <form id="form" onsubmit="return false;">
         <label for="email">
            Email
         </label>
         <input type="email" id="email" oninput="onEmailInput(event);"></input>

         <canvas id="canvas" width="100" height="100" style="display:none;"></canvas>
        
         <div id="secretContainer">
            <div id="secretDiv">
               <label for="secretFile">
                  Secret
                  <br />
                  <img id="thumbnail" width="100" height="100"></img>
               </label>
               <input type="file" id="secretFile" onchange="return onSecretFile();" accept="image/*" style="display:none;" ></input>
            </div>
         </div>
 
         <div id="logonDiv">
            <button id="button" onclick="resetSecret(); return false;">Reset secret</button>
         </div>
         
         <script>

var console = new Console();
console.log("Hello world");

var authentication = new Authentication();

var form =
   document
   .getElementById("form");
 
var canvas =
   document
   .getElementById("canvas");
   
var thumbnail =
   document
   .getElementById("thumbnail");
   

var email =
   document.getElementById("email");
   
var button =
   document.getElementById("button");
   
var secretFile =
   document.getElementById("secretFile");
    
const params = new URL(document.location.href).searchParams;
   
function onSecretFile() {
  
    
    createThumbnail(
       secretFile.files[0],
       thumbnail,
       function() {
          secretFile.value = null;
          resetSecret();
       }
    );
    
    return true;
}



function resetSecret()
{

   if (!email.value) {
      alert("Please enter your email address");
      return false;
   }
   
   
   if (!thumbnail.secret) {
      alert("Please select a secret");
      return false;
   }
   
   var lostSecret = params.get("lostSecret");
   
   if (!lostSecret) {
      alert("Invalid lost secret");
      return false;
   }
   
   thumbnail.classList.add("pressed");
   
   var promise =
      authentication.
      resetSecret(
         email.value,
         lostSecret,
         thumbnail.secret
      ).then(
         function(response) {
            if (response) {
               saveFields();
               document.location.replace("logon.php");
            }
            else {
               throw "Error resetting secret";
            }
         }
      ).catch(
         function(error) {
            alert(error);
         }
      );
      
      
      return promise;
   
   
   
}



function saveFields() {
   localStorage.setItem(
      "authentication.email",
      email.value
   );
            
   localStorage.setItem(
      email.value + ".authentication.thumbnail",
      thumbnail.src
   );
}


if (params.has("email")) {
   email.value = params.get("email");
   email.disabled = true;
}
else
   document.location.replace("logon.php");


         </script>

      </form>
      <h2><a href="/">Home</a></h2>
      
   </body>
</html>
