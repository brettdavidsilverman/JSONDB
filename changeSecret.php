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
      <script src="/client/authentication/thumbnailSecret.js"></script>
      <script src="/client/authentication/authentication.js?v=6"></script>
      <link rel="stylesheet" type="text/css" href="/style.css" />
      <link rel="stylesheet" type="text/css" href="/logon-style.css?v=4" />
      <title>Change Secret</title>
      <style>

      </style>
   </head>
   <body>
      <h1>Change Secret</h1>
      <h2>Existing users</h2>
      <p>Please provide your email address and your existing secret file, then select your new secret. Finally click Change Secret.</p>
  
      <a href="/client/authentication/authentication.js">authentication.js</a>
           
      <form id="form" onsubmit="return false;">
         <label for="email">
            Email
         </label>
         <input type="email" id="email" oninput="onEmailInput();"></input>

         <canvas id="canvas" width="100" height="100" style="display:none;"></canvas>
        

         <div id="secretContainer">
            <div id="secretDiv">
               <label for="secretFile">
                  Secret
                  <br />
                  <img id="existingThumbnail" width="100" height="100"></img>
               </label>
               <input type="file" id="secretFile" onchange="onExistingSecret(this);" accept="image/*" style="display:none;" ></input>
            </div>
            
            <div id="changeSecretDiv">
               <label for="changeSecretFile">
                  Change Secret
                  <br />
                  <img id="changeThumbnail" width="100" height="100"></img>
               </label>
               <input type="file" id="changeSecretFile" onchange="onChangeSecret(this);" accept="image/*" style="display:none;" ></input>
            </div>
         </div>
        
         <a href="lostSecret.php">Lost Secret?</a>
         <br/>
         
         
         <button id="changeSecretButton" onclick="changeSecret(); return false;">Change secret</button>
         
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
   
var existingThumbnail =
   document
   .getElementById("existingThumbnail");
   
var changeThumbnail =
   document
   .getElementById("changeThumbnail");

var email =
   document.getElementById("email");
   
var changeSecretButton =
   document.getElementById("changeSecretButton");
   

function onExistingSecret(input) {
    createThumbnail(
       input.files[0],
       existingThumbnail,
       function() {
          updateForm();
       }
    );
}

function onChangeSecret(input) {
    createThumbnail(
       input.files[0],
       changeThumbnail,
       function() {
          updateForm();
       }
    );
}

function onEmailInput() {
   updateForm();
}

function changeSecret() {
   authentication.changeSecret(
      email.value,
      existingThumbnail.secret,
      changeThumbnail.secret
   ).then(
      function (result) {
         if (result) {
            localStorage.setItem(
               email.value + ".authentication.existingThumbnail",
               changeThumbnail.src
            );
            localStorage.setItem(
               "authentication.email",
               email.value
            );
           // existingThumbnail.secret = changeThumbnail.secret;
            alert("Secret changed");
            var redirect = getRedirect();
            document.location.href =
               "logon.php?redirect=" +
               encodeURIComponent(redirect);
            return Promise.resolve(true);
         }
         else {
            alert("Invalid email or secret");
            updateForm(false);
            return Promise.resolve(false);
         }
      }
   );
}



function updateForm()
{
   
   var thumbnailSrc =
      localStorage.getItem(
         email.value + ".authentication.existingThumbnail"
      );
   
   if (thumbnailSrc)
      existingThumbnail.src = thumbnailSrc;
   else
      existingThumbnail.src = "";
   
   var enabled =
      email.value &&
      existingThumbnail.secret &&
      changeThumbnail.secret;
      
   changeSecretButton.disabled =
      !enabled;

}

email.value =
   localStorage.getItem(
      "authentication.email"
   );


updateForm();

         </script>

      </form>
      <h2><a href="/">Home</a></h2>
      
   </body>
</html>
