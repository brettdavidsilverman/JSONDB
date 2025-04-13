<?php
   require_once '../../server/functions.php';
   
   http_response_code(401);
?>
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
      <title>Logon</title>
      <style>

      </style>
   </head>
   <body>
      <h1>Logon</h1>
      <h2><a href="createUser.php">New users<a></h2>
      
      <h2>Existing users</h2>
      <p>Please provide your email address and your secret file, then click logon.</p>
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
               <label for="secretFile" onclick="return checkLogoff();">
                  Secret
                  <br />
                  <img id="thumbnail" width="100" height="100"></img>
               </label>
               <input type="file" id="secretFile" onchange="return onSecretFile();" accept="image/*" style="display:none;" ></input>
            </div>
         </div>
         <br />
         <a href="lostSecret.php">Lost Secret?</a>
         <br />
         <a href="changeSecret.php">Change secret</a>
         
         <br/>
 
         <div id="logonDiv">
            <button id="logoffButton" onclick="logoff(); return false;">Logoff</button>
            <button id="logonButton" onclick="logon(); return false;">Logon</button>
           
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
   
var logonButton =
   document.getElementById("logonButton");
   
var logoffButton =
   document.getElementById("logoffButton");

var secretFile =
   document.getElementById("secretFile");
    
function checkLogoff() {
   if (authentication.authenticated) {
       logoff(true);
       return false;
    }
    return true;
}

function onSecretFile() {
  
    
    createThumbnail(
       secretFile.files[0],
       thumbnail,
       function() {
          if (email.value)
             logon();
       }
    );
    
    return true;
}


function onEmailInput(event) {
   if (authentication.authenticated) {
      authentication.logoff().
      then(
         function() {
            updateForm(false);
         }
      );
   }
   else
      updateForm(false);
}


function logon()
{

   if (!email.value) {
      alert("Please enter your email address");
      return false;
   }
   
   
   if (!thumbnail.secret) {
      alert("Please select a secret");
      return false;
   }
   
   thumbnail.classList.add("pressed");
   
   //prompt("secret: ", thumbnail.secret);
   
   var redirect = getRedirect();
          
   var promise =
      authentication.
      logon(
         email.value,
         thumbnail.secret
      ).then(
         function(response) {
            if (response) {
               saveFields();
               document.location.replace(redirect);
               return;
            }
            else {
               authentication.
               getUserEmailExists(email.value).
               then(
                  function(exists) {
                     if (exists)
                        alert("Invalid email or secret.");
                     else {
                        if (confirm("Email does not exist or has not been validated. Do you wish to register as a new user?"))
                        {
                           document.location.href =
                              "createUser.php?redirect=" +
                           encodeURIComponent(redirect);
                          
                           return;
                        }
                     }
                  }
               )
               .catch(
                  (error) => {
                     alert(error);
                  }
               );
            }
         }
      ).catch(
         function(error) {
            alert(error);
         }
      ).finally(
         function() {
            updateForm();
         }
      );
      
      
      return promise;
   
   
   
}

function logoff(check = true)
{
   if (check && !confirm("Logoff?"))
      return false;
      
   thumbnail.secret = null;
   thumbnail.classList.remove("pressed");

   authentication.logoff().then(
      function(response) {
         updateForm();
      }
   );
   
   return true;

   
}

function getRedirect() {
   const params = new URL(document.location.href).searchParams;
   
   var redirect;
   
   if (params.has("redirect"))
      redirect = params.get("redirect");
   else
      redirect = "/";
      
   return redirect;
               
}



function updateForm(setFields = true)
{
   var params = new URLSearchParams(location.search);
   
   if (setFields) {
      
      var _email;
      if (params.has("email")) {
         _email = params.get("email");
      } 
      else {
         _email =
            localStorage.getItem(
               "authentication.email"
            );
      }
      
      if (_email)
         email.value = _email;
         
    
   }

   var thumbnailSrc =
      localStorage.getItem(
         email.value + ".authentication.thumbnail"
      );
   
   if (thumbnailSrc)
      thumbnail.src = thumbnailSrc;
   else
       thumbnail.src = "";
   
   logonButton.disabled = true;
   logoffButton.disabled = true;
   
   if (authentication.authenticated)
   {
      thumbnail.classList.add("pressed");
      logoffButton.disabled = false;

   }
   else
   {
      thumbnail.classList.remove("pressed");
      logoffButton.disabled = true;
   }
   
   authentication.
   getUserEmailExists(email.value).
   then(
      function(exists) {
         logonButton.disabled = (thumbnail.secret == null || !exists);
      }
   );
   
   secretFile.value = null;

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

function update()
{
 
   authentication.refresh().then(
         function(auth){
            updateForm();
         }
      );

}

update();

         </script>

      </form>
      <h2><a href="/">Home</a></h2>
      
   </body>
</html>
