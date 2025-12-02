<?php
   
   require_once "server/functions.php";
   
   authenticate();
?>
<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <title id="title"><?php echo getConfig()["Domain"] ?></title>
      <script src="/client/head.js"></script>
<!--
      <script src="/client/stream/stream.js"></script>
      <script src="/client/power-encoding/power-encoding.js"></script>
      <script src="/client/id/id.js"></script>
      <script src="/client/evaluate.js"></script>
      <script src="/client/punycode.js"></script>
      <script src="/client/origin.js"></script>
-->
      <script src="/client/authentication/authentication.js?v=28"></script>
      <link rel="stylesheet" type="text/css" href="style.css"/>
   </head>
   <body>

      <a id="logoff">Logoff/Change secret</a>
      <h1 id="h1"></h1>
       
      <script type="module">
var authentication =
   new Authentication();

setup();

try {
    await go();
}
catch (error) {
    alert(error);
}

async function go() {
    
    var path =
        //decodeURIComponent(
            document.location.search.substr(1);
     //   );

    const f =
        await authentication
        .createProcess(path);
        
    document.writeln("<pre>");
    document.writeln(f.toString());
    document.writeln("</pre>");
    document.close();
    
    alert(f());

}

function setup() {
   var logoff =
      document.getElementById("logoff");
   
   logoff.href = 
      "/client/authentication/logon.php?redirect=" +
      encodeURIComponent(document.location.href);
      
    var header = document.getElementById("h1");
    var title = document.getElementById("title");

    var origin =
   // punycode.toUnicode(
      window.location.hostname;

    if (header)
        header.innerText = "Process " + origin;
   
    if (title)
        title.innerText = origin;
}
      </script>
      
   </body>

</html>