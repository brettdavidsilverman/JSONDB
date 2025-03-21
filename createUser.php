<?php
   require_once "server/functions.php";
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
      <script src="/client/authentication/sha512.js"></script>
      <script src="/client/authentication/thumbnailSecret.js?v=1"></script>
      <script src="/client/authentication/authentication.js?v=7"></script>
      <link rel="stylesheet" type="text/css" href="/style.css" />
      <link rel="stylesheet" type="text/css" href="/logon-style.css?v=4" />
      <title>Register user</title>
      <style>

      </style>
   </head>
   <body>
      <h1>Register new user</h1>
      <p>Please provide your email address and select your secret file. Then click Register</p>
      
      <a href="/client/authentication/authentication.js">authentication.js</a>
           
      <form id="form" onsubmit="return false;">
                  
         <canvas id="canvas" width="100" height="100" style="display:none;"></canvas>
        
         <label for="email">
            Email
         </label>
         <input type="email" id="email" oninput="onEmailInput()"></input>
         <div id="emailExists" class="error" style="display:none;">This email already exists</div>
         <div id="secretContainer">
            <div id="secretDiv">
               <label for="secretFile">
                  Secret
                  <br />
                  <img id="thumbnail" width="100" height="100"></img>
               </label>
               <input type="file" id="secretFile" onchange="onSecretFile();" accept="image/*" style="display:none;" ></input>
            </div>
         </div>
         <br />
         <button id="createUserButton" class="g-recaptcha" 
            data-sitekey="<?php echo getConfig()->{'reCaptcha'}->{'siteKey'}; ?>"
            data-callback='createUser' 
            data-action='submit'
            disabled='true'
         >Register</button>
            
         <script>

var console = new Console();
console.log("Hello world");

var authentication = new Authentication();

var email =
   document.getElementById("email");

var canvas =
   document.getElementById("canvas");
   
var secretFile =
   document.getElementById("secretFile");
   
var thumbnail =
   document.getElementById("thumbnail");
   
var button =
   document.getElementById("createUserButton");
  
var emailExists =
   document.getElementById("emailExists");
  
   
function onSecretFile() {
   createThumbnail(
      secretFile.files[0], 
      thumbnail,
      function(secret) {
         updateForm();
      }
   );
}

function createUser(token)
{
   if (!email.value) {
      alert("Please enter your email address");
      return;
   }
   
   if (!confirm("This will send a link to validate your email. Continue?"))
      return;
   
   authentication.createUser(
      token,
      email.value,
      thumbnail.secret
   ).then(
      function(response) {
         if (response) {
            alert("Please check your inbox for the link to validate your email");
            var redirect = getRedirect();
            document.location.href = 
               "logon.php?redirect=" +
               encodeURIComponent(redirect);
         }
         else
            alert("Error sending email");
      }
   );

   
}

function onEmailInput() {
   updateForm();
}

function updateForm() {

   authentication.getUserEmailExists(
      email.value
   ).then(
      function (exists)
      {
         if (exists)
            emailExists.style.display = "block";
         else
            emailExists.style.display = "none";
            
         var enabled =
            email.value &&
            !exists &&
            thumbnail.secret;
            
         button.disabled = !enabled;
         
      }
   );
}


window.onload = function() {
   button.disabled = true;
}
         </script>

      </form>
      <h2><a href="/">Home</a></h2>
      
   </body>
</html>
