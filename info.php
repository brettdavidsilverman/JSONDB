<?php
   $url = '/logon.php';
   $redirect = $_SERVER['REQUEST_URI'];
   $query = '?redirect=' . urlencode($redirect);
   
   $url = $url . $query;
?>
<!DOCTYPE html>
<html lang="en">
   <head>
   </head>
   <body>
      bee.fish
   </body>
</html>