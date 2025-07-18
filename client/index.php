<?php
require_once "../server/functions.php";

?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
   <head>
      <script src="/client/head.js"></script>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=1"/>
      <link rel="stylesheet" type="text/css" href="/style.css" />
      <link rel="stylesheet" type="text/css" href="style.css" />

      <title><?php echo getConfig()["Domain"] ?></title>
   </head>
   <body>
      <h1 id="h1"><?php echo getConfig()["Domain"] ?> client</h1>
      <ul>
         <li>
            <a href="console/">Console</a>
         </li>
         <li>
            <a href="authentication/logon.php?redirect=/client">Logon</a>
         </li>
         <li>
            <a href="stream/">Stream bits</a>
         </li>
         <li>
            <a href="power-encoding/">Power Encoding</a>
         </li>
         <li>
            <a href="id/">Id timestamped identifier</a>
         </li>
         <li>
            <a href="pointer/">Pointer</a>
         </li>
         <li>
            <a href="storage/">Storage</a>
         </li>
         <li>
            <a href="draw/">Draw</a>
         </li>
         <li>
            <a href="parser/">Javascript Parser</a>
         </li>
         <li>
            <a href="encryption/">Encryption</a>
         </li>
      </ul>
   </body>
</html>
