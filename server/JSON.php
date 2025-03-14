<?php
   declare(strict_types=1);
   require_once 'functions.php';
   
   authenticate();
   
   header('content-type: text/plain; charset=utf-8');
   echo "URI❤️\t" . $_SERVER['REQUEST_URI'] . "\r\n";
   echo "Query💜\t" . $_SERVER['QUERY_STRING'];
   
   
   
   require_once 'jsonstreamingparser/vendor/autoload.php';

   $testfile = __DIR__.'/jsonstreamingparser/tests/data/example.json';

   $listener = new \JsonStreamingParser\Listener\InMemoryListener();
   $stream = fopen($testfile, 'r');
   try {
      $parser = new \JsonStreamingParser\Parser($stream, $listener);
      $parser->parse();
      fclose($stream);
   } catch (Exception $e) {
      fclose($stream);
       throw $e;
   }

   var_dump($listener->getJson());

?>