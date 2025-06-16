<?php
   
   declare(strict_types=1);
   
   require_once '../functions.php';
      /*
    http_response_code(200);
    
    header('Content-Type: text/plain; charset=utf-8');
    echo "hello 🐝";
    
    return;
    */
   $connection = getConnection();
   
   $method = $_SERVER['REQUEST_METHOD'];

   if ($method === "POST") {
       
      $file = null;
      if (array_key_exists("file", $_FILES)) {
         if ($_FILES["file"]["error"] == 0) {
            $file = $_FILES["file"]["tmp_name"];
         }
      }
      handlePost($connection, $file);
   }
   else if ($method === "GET") {
      
      if (getQuery() === "")
         handleGet($connection);
      else
         handleSearch($connection);
         
   }
      
   $connection->close();
      flush();

 
   
   
?>