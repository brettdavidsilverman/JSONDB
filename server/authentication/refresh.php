<?php

require_once 'functions.php';

$credentials = refresh();
   
http_response_code(200);

setCredentialsCookie($credentials);
   
?>