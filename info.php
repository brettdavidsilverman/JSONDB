<?php
$conn = require('server/connection.php');

require_once 'server/userEmailExists.php';

$exists = userEmailExists($conn, 'brettdavidsilverman@gmail.com');

$conn->close();

echo is_null($exists) ?
   'null' : (
      $exists ?
         'true':
         'false'
   );
?>