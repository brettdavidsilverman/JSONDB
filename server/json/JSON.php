<?php
   declare(strict_types=1);
   require_once '../functions.php';
   require_once '../authentication/functions.php';
   require_once 'functions.php';
      
   //header('Content-Encoding: gzip');
   //echo "URI❤️\t" . $_SERVER['REQUEST_URI'] . "\r\n";
   //echo "Query💜\t" . $_SERVER['QUERY_STRING'] . "\r\n";
   
   
   $testfile = __DIR__.'/jsonstreamingparser/tests/data/example.json';
   $testfile = __DIR__.'/../../tests/test.json';
   $testfile = __DIR__.'/../../tests/large.json';
   

   $connection = getConnection();
   
   $method = $_SERVER['REQUEST_METHOD'];

   if ($method === "POST")
      handlePost($connection);
   else if ($method === "GET")
      handleGet($connection);
      
   $connection->close();
      flush();

 
   
   
?>