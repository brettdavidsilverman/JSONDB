<!DOCTYPE html>
<html lang="en">
   <head>
      <script src="/client/head.js"></script>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <!--
      <script src="https://www.google.com/recaptcha/api.js"></script>
      <script src="/client/fetch.js"></script>
      -->
      <script src="/client/console/console.js"></script>
      <script src="sha512.js"></script>
      <script src="thumbnailSecret.js"></script>
      <script src="authentication.js?v=9"></script>
      <link rel="stylesheet" type="text/css" href="/style.css" />
      <link rel="stylesheet" type="text/css" href="style.css" />
      <title>Change Secret</title>
      <style>

      </style>
   </head>
   <body>
      <h1>Change Secret</h1>
      <h2>Existing users</h2>
      <p>Please provide your email address and your existing secret file, then select your new secret. Finally click Change Secret.</p>
  
      <a href="authentication.js">authentication.js</a>
           
      <form id="form" onsubmit="return false;">
         <label for="email">
            Email
         </label>
         <input type="email" id="email" oninput="onEmailInput();"></input>

         <canvas id="canvas" width="100" height="100" style="display:none;"></canvas>
        

         <div id="secretContainer">
            <div id="secretDiv">
               <label for="secretFile">
                  Current Secret
                  <br />
                  <img id="oldThumbnail" width="100" height="100"></img>
               </label>
               <input type="file" id="secretFile" onchange="onOldSecret(this);" accept="image/*" style="display:none;" ></input>
            </div>
            
            <div id="changeSecretDiv">
               <label for="changeSecretFile">
                  New Secret
                  <br />
                  <img id="newThumbnail" width="100" height="100"></img>
               </label>
               <input type="file" id="changeSecretFile" onchange="onNewSecret(this);" accept="image/*" style="display:none;" ></input>
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
   
var oldThumbnail =
   document
   .getElementById("oldThumbnail");
   
var newThumbnail =
   document
   .getElementById("newThumbnail");

var email =
   document.getElementById("email");
   
var changeSecretButton =
   document.getElementById("changeSecretButton");
   

function onOldSecret(input) {
    createThumbnail(
       input.files[0],
       oldThumbnail,
       function() {
          updateForm();
       }
    );
}

function onNewSecret(input) {
    createThumbnail(
       input.files[0],
       newThumbnail,
       function() {
          updateForm();
       }
    );
}

function onEmailInput() {
   updateForm();
}

function changeSecret() {
    
   authentication.logoff().
   then(
      function(response) {
         var promise =
            authentication.changeSecret(
               email.value,
               oldThumbnail.secret,
               newThumbnail.secret
            );
         return promise;
      }
   ).then(
      function (result) {
         if (result) {
            localStorage.setItem(
               email.value + ".authentication.thumbnail",
               newThumbnail.src
            );
            localStorage.setItem(
               "authentication.email",
               email.value
            );
            alert("Secret changed");
            redirect("logon.php");
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
         email.value + ".authentication.thumbnail"
      );
   
   if (thumbnailSrc)
      oldThumbnail.src = thumbnailSrc;
   else
      oldThumbnail.src = "";
   
   if (oldThumbnail.secret)
      oldThumbnail.classList.add("pressed");
   else
      oldThumbnail.classList.remove("pressed");

   if (newThumbnail.secret)
      newThumbnail.classList.add("pressed");
   else
      newThumbnail.classList.remove("pressed");
      
   var enabled =
      email.value &&
      oldThumbnail.secret &&
      newThumbnail.secret;
      
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