<?php
   
   require_once "server/functions.php";
   
   authenticate();
?>
<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <title id="title">bee.fish</title>
      <script src="/client/head.js"></script>
      <script src="/client/stream/stream.js"></script>
      <script src="/client/power-encoding/power-encoding.js"></script>
      <script src="/client/id/id.js"></script>
      <script src="/client/evaluate.js"></script>      <script src="/client/logon/authentication.js"></script>
      <script src="/client/punycode.js"></script>
      <link rel="stylesheet" type="text/css" href="style.css"/>
   </head>
   <body>

      <a id="logoff">Logoff/Change secret</a>
      <h1 id="h1"></h1>
      <script src="/client/origin.js"></script>
      
      <script>
setup();

go();

function go() {
    
   var path =
      decodeURIComponent(
         document.location.search.substr(1)
      );

   fetch(path).
   then(
      function(response) {
         return response.text()
      }
   ).
   then(
      function(text) {
         // document.write(text);
         return JSON.parse(text);
      }
   ).
   then(
      function(json) {
         json = evaluate(json);
      }
   );
}

function setup() {   
   var logoff =
      document.getElementById("logoff");
   
   logoff.href = 
      "/logon.php?redirect=" +
      encodeURIComponent(document.location.href);
}
      </script>
      
   </body>

</html>