<?php
   header('content-type: text/plain; charset=utf-8');
   echo "URI❤️\t" . $_SERVER['REQUEST_URI'] . "\r\n";
   echo "Query\t" . $_SERVER['QUERY_STRING'];
   
?>