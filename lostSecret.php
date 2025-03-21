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
      <script src="/client/authentication/authentication.js?v=6"></script>
      <link rel="stylesheet" type="text/css" href="/style.css" />
      <link rel="stylesheet" type="text/css" href="/logon-style.css?v=3" />
      <title>Lost Secret</title>
      <style>
      </style>
   </head>
   <body>
      <h1>Lost Secret?</h1>
      <p>Please provide your email address and then click Lost Secret</p>
      
      <a href="/client/authentication/authentication.js">authentication.js</a>
           
      <form id="form" onsubmit="return false;">
         <label for="email">
            Email
         </label>
         <input type="email" id="email"></input>

         <button class="g-recaptcha" 
            data-sitekey="<?php echo getConfig()->{'reCaptcha'}->{'siteKey'}; ?>"
            data-callback='lostSecret' 
            data-action='submit'>Lost Secret</button>
         
         <script>

var console = new Console();
console.log("Hello world");

var authentication = new Authentication();

var email =
   document.getElementById("email");
   

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
         }
         else
            alert("Error sending email");
      }
   );

   
}

         </script>

      </form>
      <h2><a href="/">Home</a></h2>
      
   </body>
</html>
