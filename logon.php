<!DOCTYPE html>
<html lang="en">
   <head>
      <script src="/client/head.js"></script>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <script src="/client/fetch.js"></script>
      <script src="/client/console/console.js"></script>
      <script src="/client/authentication/sha512.js"></script>
      <script src="/client/authentication/authentication.js"></script>
      <link rel="stylesheet" type="text/css" href="/style.css" />
      <link rel="stylesheet" type="text/css" href="/logon-style.css" />
      <title>Bee.Fish logon</title>
      <style>
      </style>
   </head>
   <body>
      <h1>Logon</h1>
      <p>Please provide your email address and a secret to logon.</p>
      <div>
         <a href="resetPasswordLink.php">Reset password</a>
      </div>
      <a href="/client/authentication/authentication.js">authentication.js</a>
      <form id="form" onsubmit="return false;">
         <label for="email">
            Email
         </label>
         <input type="email" id="email"></input>
<?php
   $thumbnailId  = "thumbnail";
   include "include/thumbnail.php";
?>
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

thumbnail.onclick = function(event)
{
   if (authentication.authenticated) {
      logoff();
      return false;
   }
   else
      return true;
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
   
   authentication.logon(email.value, thumbnail.secret).then(
      function(response) {
         if (response) {
            saveFields();
            const params = new URL(document.location.href).searchParams;
            if (params.has("redirect")) {
               redirect = params.get("redirect");
               document.location.href = redirect;
            }
            else
               updateForm();
         }
         else {
           authentication.getUserEmailExists(email.value)
           .then(
              function(exists) {
                 if (exists) {
                    alert("Invalid email or secret or email not validated yet.");
                    updateForm(false);
                 }
                 else {
                    if (confirm("Email does not exist. Do you wish to create a new user?"))
                    {
                       authentication.createUser(
                          email.value, thumbnail.secret
                       ).
                       then(
                          function (ok) {
                             if (ok) {
                                saveFields();
                                alert("Please check your inbox to validate your email");
                             }
                             else {
                                alert("Error occurred");
                             }
                             updateForm(false);
                          }
                       );
                       
                    }
                    else {
                       
                       updateForm(false);
                    }
                 }
                 
              }
           );
           
         }
      }
   ).catch(
      function(error) {
         alert(error);
         updateForm();
      }
   ); 
   
   
   
}

function logoff()
{
   if (!confirm("Logoff?"))
      return;
      
   thumbnail.secret = null;
   thumbnail.classList.remove("pressed");
   authentication.logoff().then(
      function(response) {
         form.reset();
         updateForm();
      }
   )

   
}

// Returns a base64 encode SHA-512 hash
// of the file
function getFileHash(file) {
    const sha = new jsSHA("SHA-512", "ARRAYBUFFER");
    var fileReader = new FileReader();
    const promise = new Promise(
        function(resolve, reject) {
            fileReader.onloadend = function(event) {
                const fileReader = event.target;
                var result = fileReader.result;
                var arrayBuffer = result;
                var view = new Uint8Array(arrayBuffer);
                sha.update(view);
                var hash = sha.getHash("B64");
                resolve(hash);
            }
            fileReader.readAsArrayBuffer(file);
        }
    );

    return promise;

}


function createThumbnail(file, thumbnail)
{

   // Create a thumbail copy from
   // secret file and draw it
   // on the canvas.
   thumbnail.src = "";
   
   var _this = this;
     
   prepareCanvas(canvas);
      
   var image;
      
      
   // Read the secretFile
   var fileReader = new FileReader();
      
   // onload fires after reading is complete
   fileReader.onload = createImage;
      
   // begin reading
   fileReader.readAsDataURL(file);
      
    
   function createImage()
   {
      image = new Image();
         
      image.width = 100;
            
      image.height = 100;
            
      image.onload = imageLoaded;
      
      image.src = fileReader.result;
         
   }
      
   function imageLoaded()
   {
   
      var context = canvas.getContext("2d");
      
      // draw the image
      context.drawImage(
         image, 0, 0, canvas.width, canvas.height
      );         

      // get the image
      var jpeg =
         canvas.toDataURL("image/jpeg", 0.5);
     
      // set the thumbnail
      thumbnail.src = jpeg;

      createSecret(file, thumbnail);
      
   }
      
   function prepareCanvas(canvas)
   {
      canvas.width = 100;    
      canvas.height = 100;
      
      var context = canvas.getContext("2d");
         
      // draw the image
      context.clearRect(
         0, 0, canvas.width, canvas.height
      );         
   }
      

}

function createSecret(file, thumbnail)
{

   thumbnail.classList.remove("pressed");
   
   thumbnail.style.filter = "grayscale(100%)";
   
   getFileHash(file)
   .then(
      function(secret) {
         thumbnail.style.filter = "none";
         thumbnail.secret = secret;
         updateForm(false);
         if (email.value && thumbnail.id == "thumbnail")
            logon();
      }
   );
   
}

function updateForm(setFields = true)
{
   
   if (setFields) {
      var _email =
         localStorage.getItem(
            "authentication.email"
         );
      
      if (_email)
         email.value = _email;
      
      var thumbnailSrc = localStorage.getItem(
         "authentication.thumbnail"
      );
   
      if (thumbnailSrc)
         thumbnail.src = thumbnailSrc;
   }

   if (authentication.authenticated)
   {
      thumbnail.classList.add("pressed");
      logoffButton.disabled = false;
      logonButton.disabled = true;

   }
   else
   {
      thumbnail.classList.remove("pressed");
      logoffButton.disabled = true;
      logonButton.disabled = (thumbnail.secret == null);
   }

      
}

function saveFields() {
   localStorage.setItem(
      "authentication.email",
      email.value
   );
            
   localStorage.setItem(
      "authentication.thumbnail",
      thumbnail.src
   );
}

function update()
{
   form.reset();
   
   if (authentication.authenticated)
      updateForm();
   else
      authentication.getStatus().then(
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
