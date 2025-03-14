<?php
   require_once "server/functions.php";
   http_response_code(401);
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
      <script src="/client/authentication/authentication.js?v=6"></script>
      <link rel="stylesheet" type="text/css" href="/style.css" />
      <link rel="stylesheet" type="text/css" href="/logon-style.css?v=3" />
      <title>Bee.Fish logon</title>
      <style>

      </style>
   </head>
   <body>
      <h1>Logon</h1>
      <p>Please provide your email address and a secret then click logon.</p>
      
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
                  <img id="existingThumbnail" width="100" height="100"></img>
               </label>
               <input type="file" id="secretFile" onchange="createThumbnail(this.files[0], document.getElementById('existingThumbnail'));" accept="image/*" style="display:none;" ></input>
            </div>
            
            <div id="changeSecretDiv">
               <label for="changeSecretFile">
                  Change Secret
                  <br />
                  <img id="changeThumbnail" width="100" height="100"></img>
               </label>
               <input type="file" id="changeSecretFile" onchange="createThumbnail(this.files[0], document.getElementById('changeThumbnail'));" accept="image/*" style="display:none;" ></input>
            </div>
         </div>
        
        
         <button class="g-recaptcha" 
            data-sitekey="<?php echo getConfig()->{'reCaptcha'}->{'siteKey'}; ?>"
            data-callback='lostSecret' 
            data-action='submit'>Lost Secret</button>
         
         <button id="changeSecretButton" onclick="changeSecret(); return false;">Change secret</button>
          
         <br />
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
   
var existingThumbnail =
   document
   .getElementById("existingThumbnail");
   
var changeThumbnail =
   document
   .getElementById("changeThumbnail");

var email =
   document.getElementById("email");
   
var logonButton =
   document.getElementById("logonButton");
   
var logoffButton =
   document.getElementById("logoffButton");

var changeSecretDiv =
   document.getElementById("changeSecretDiv");
   
var changeSecretButton =
   document.getElementById("changeSecretButton");
   
existingThumbnail.onclick = function(event)
{
   if (authentication.authenticated) {
      logoff();
      return false;
   }
   else
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
            existingThumbnail.secret = changeThumbnail.secret;
            updateForm(true);
            alert("Secret changed");
            return login();
         }
         else {
            alert("Invalid email or secret");
            updateForm(false);
            return Promise.resolve(false);
         }
      }
   );
}

function logon()
{

   if (!email.value) {
      alert("Please enter your email address");
      return false;
   }
   
   
   if (!existingThumbnail.secret) {
      alert("Please select a secret");
      return false;
   }
   
   existingThumbnail.classList.add("pressed");
   
   var promise;
   
   const params = new URLSearchParams(location.search);
   if (params.has("lostSecret")) {
      promise = authentication.
         resetSecret(
            email.value,
            params.get("lostSecret"),
            existingThumbnail.secret
         ).then(
            function(response) {
               if (response) {
                  alert("Secret changed");
                  return authentication.logon(
                     email.value,
                     existingThumbnail.secret
                  );
               }
               else {
                  alert("Error setting new secret");
               }
            }
         );
   }
   else
      promise = authentication.
         logon(
            email.value,
            existingThumbnail.secret
         );
   

   promise.then(
      function(response) {
         if (response) {
            saveFields();
            
            const params = new URL(document.location.href).searchParams;
            if (params.has("redirect"))
               redirect = params.get("redirect");
            else
               redirect = "/";
               
            document.location.href = redirect;

         }
         else {
           authentication.getUserEmailExists(email.value)
           .then(
              function(exists) {
                 if (exists) {
                    alert("Invalid email or secret.");
                    updateForm(false);
                 }
                 else {
                    if (confirm("Do you wish to register as a new user?"))
                    {
                       authentication.createUser(
                          email.value, existingThumbnail.secret
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

function logoff(check = true)
{
   if (check && !confirm("Logoff?"))
      return;
      
   existingThumbnail.secret = null;
   existingThumbnail.classList.remove("pressed");
   authentication.logoff().then(
      function(response) {
         updateForm();
      }
   )

   
}

function lostSecret(token)
{
   if (!email.value) {
      alert("Please enter your email address");
      return;
   }
   
   if (!confirm("This will send a link to reset your password to your email inbox. Continue?"))
      return;
   
   authentication.lostSecret(
      token,
      email.value
   ).then(
      function(response) {
         if (response) {
            alert("Please check your inbox for the link to reset your password");
            authentication.logoff().then(
               function() {
                  updateForm(false);
               }
            );
         }
         else
            alert("Error sending email");
      }
   );

   
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
     
      // set the existingThumbnail
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
         if (thumbnail == existingThumbnail) {
            localStorage.setItem(
               email.value + ".authentication.existingThumbnail",
               thumbnail.src
            );
         }
      }
   ).then(
      function() {
         updateForm(false);
      }
   );
   
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
            email.value + ".authentication.existingThumbnail"
         );
   
      if (thumbnailSrc)
         existingThumbnail.src = thumbnailSrc;
      else
         existingThumbnail.src = "";
   
   
   
   if (authentication.authenticated)
   {
      existingThumbnail.classList.add("pressed");
      logoffButton.disabled = false;
      logonButton.disabled = true;

   }
   else
   {
      existingThumbnail.classList.remove("pressed");
      logoffButton.disabled = true;
      logonButton.disabled = (existingThumbnail.secret == null);
   }
   
   authentication.
   getUserEmailExists(email.value).
   then(
      function(exists) {
         const params = new URLSearchParams(location.search);

         if (exists &&
            !params.has("lostSecret") &&
            !authentication.authenticated)
         {
            
            changeSecretButton.disabled =
            !(
               email.value &&
               existingThumbnail.secret &&
               changeThumbnail.secret
            );
            changeSecretButton.style.display = "inline";
            changeSecretDiv.style.display = "block";
         }
         else {
            changeSecretButton.disabled = true;
            changeSecretButton.style.display = "none";
            changeSecretDiv.style.display = "none";
         }
      }
   );

}

function saveFields() {
   localStorage.setItem(
      "authentication.email",
      email.value
   );
            
   localStorage.setItem(
      email.value + ".authentication.existingThumbnail",
      existingThumbnail.src
   );
}

function update()
{
   form.reset();
   
   var params = new URLSearchParams(location.search);
   
   if (params.has("lostSecret")) {
      authentication.logoff().then(
         function(auth) {
            localStorage.setItem(
               email.value + ".authentication.existingThumbnail",
               ""
            );
            updateForm();
         }
      );
   }
   else {
      if (authentication.authenticated)
         updateForm();
      else
         authentication.getStatus().then(
            function(auth){
               updateForm();
            }
         );
   }
}

update();

         </script>

      </form>
      <h2><a href="/">Home</a></h2>
      
   </body>
</html>
