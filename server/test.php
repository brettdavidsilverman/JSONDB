<?php

   http_response_code(200);
   /*
   header(
      "Access-Control-Allow-Origin: *"
   );
   */
   
   
   header("Content-Type: text/plain");
   date_default_timezone_set('UTC');
   echo "Hello World 😄🌍";
    
?>