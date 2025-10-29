<?php

require_once 'JSONDBListener.php';
require_once 'ValueCountListener.php';

class PathException extends Exception
{
    public $path;
    public $errorPath;
    public $errorIndex;

    public function __construct($message, $listenerOrPath, $errorIndex) {
        $path = null;
        $listener = null;
        
        if (is_string($listenerOrPath))
            $path = $listenerOrPath;
        else {
            $listener = $listenerOrPath;
            $path = $listener->path;
        }
        $this->path = encodeSlashes($path);
        
        $this->errorIndex = $errorIndex;

        if (!is_null($errorIndex)) {
            $paths = explode("/", $path);
            $paths[$errorIndex] = 
                "{" . urldecode($paths[$errorIndex]) . "}";

            $this->errorPath =
                implode("/", $paths);

            $_message = $message . " " .
                $this->errorPath;
        }
        else
            $_message = $message;

        if (!is_null($listener))
            $listener->cancelDocument();
            
        parent::__construct($_message);
        

        
    }

};

class CancelException extends Exception
{
    public function __construct($listener = null) {
        parent::__construct("Cancelled");
        if (!is_null($listener))
            $listener->cancelDocument();
    }
    
};

class LockedException extends PathException
{
    
    public function __construct($message, $listener, $errorIndex) {
        parent::__construct($message, $listener->path, $errorIndex);
    }
    
    
};

function readFromDatabase(
    $credentials,
    $path
)
{
    $connection = getConnection();
    
    $result = null;
    
    try {
        $result = readFromDatabaseEx(
            $connection,
            $credentials,
            $path,
            null, // stream
            true  // returnObject
        );
    }
    catch (Exception $ex) {
    }
    
    $connection->close();
    
    return $result;
}

function readFromDatabaseEx(
    $connection,
    $credentials,
    $path,
    $stream = null,
    $returnObject = false
)
{
    
    if (is_null($stream)) {
        $stream = fopen("php://temp", "w+");
    }
    
    writeValuesToStream(
        $connection,
        $credentials,
        $path,
        $stream
    );

    if (!$returnObject)
        return;
        
    rewind($stream);
    
    $string =
        stream_get_contents($stream);
    
    return json_decode(
        $string,
        true // associative
    );

}

function writeToDatabase(
    $credentials,
    $path,
    $object
)
{
    
    if (is_null($path))
       return null;
       
    
    $result = null;
    
    $connection = getConnection();

    $result = writeToDatabaseEx(
        $connection,
        $credentials,
        $path,
        $object,
        null, //$stream
        $listener,
        null //$jobPath
    );

     
    $connection->close();


    return $result;
}

function writeToDatabaseEx(
    $connection,
    $credentials,
    $path,
    $object = null,
    $stream = null,
    & $listener,
    $jobPath = null
)
{
    
    if (is_null($path))
       return null;
    
    $listener = new JSONDBListener(
        $connection,
        $credentials,
        $path,
        $object,
        $stream,
        $jobPath
    );
    
    $listener->writeToDatabase();
    
    
    
    return $listener->newPath;
    
}


function handleGet()
{
    $credentials = authenticate();

    http_response_code(200);
    
    $type = "application/json; charset=utf-8";
    if (array_key_exists("type", $_GET))
    {
        if ($_GET["type"] === "text")
           $type = "text/plain; charset=utf-8";
    }
        
    header("Content-Type: " . $type);
      
    setCredentialsCookie($credentials);
    
    $stream = fopen("php://output", "w");
    $path = getPath();
    
    $connection = getConnection();

    try {


        readFromDatabaseEx(
            $connection,
            $credentials,
            $path,
            $stream,
            false
        );
        
        
    }
    catch(PathException $ex) {
        
        $error = [
            "message" => $ex->getMessage(),
            "path" => $ex->path
        ];

       echo json_encode(
            [
               "{Error}" => $error
            ]
        );

        return;
    }
    catch (Exception $ex) {
        $error = [
            "label" => $ex->getMessage(),
            "path" => $path,
            "file" => $ex->getFile(),
            "line" => $ex->getLine(),
            "trace" => $ex->getTrace()
        ];

        echo json_encode(
            [
               "{Error}" => $error
            ]
        );
        
    }
    finally {
        $connection->close();
    }
}

function handlePost()
{

    $credentials = authenticate(true);

    http_response_code(200);
    setCredentialsCookie($credentials);
        
    
    header('Content-Type: application/json; charset=utf-8');
    
    $newPath = null;
    $error = null;
    $jobPath = null;
    $jobStatus = null;
    $path = getPath();
    $listener = null;
    $startTime = time();
    
    if (array_key_exists("jobPath", $_POST))
        $jobPath = $_POST["jobPath"];
     
    $file = "php://input";

    try {
        
        $connection = getConnection();
        
        if (isset($_FILES["uploadFile"])) {
            
            if ($_FILES["uploadFile"]["error"] == UPLOAD_ERR_OK) {
                $file = $_FILES["uploadFile"]["tmp_name"];
            }
            else {
               throw new CancelException();
            }
        }

        
        
        $inputStream = fopen($file, 'r');
        
        // Parse stream into database
        $newPath = writeToDatabaseEx(
            $connection,
            $credentials,
            $path,
            null, //$object
            $inputStream,
            $listener,
            $jobPath
        );

        // Result is the new path
        echo encodeString($newPath);
    
        return true;
        
    
    }
    catch (mysqli_sql_exception $ex) {

        $error = [
            "label" => $ex->getMessage(),
            "path" => $path,
            "jobPath" => $jobPath,
            "timeTaken" =>  (time() - $startTime),
            "file" => $ex->getFile(),
            "line" => $ex->getLine(),
            "trace" => $ex->getTrace()
        ];
    }
    catch (PathException $ex) {
        $error = [
            "label" => $ex->getMessage(),
            "timeTaken" =>  (time() - $startTime),
            "path" => $ex->path,
            "jobPath" => $jobPath
        ];
    }
    catch (CancelException $ex) {
        $error = [
            "label" => "Cancelled",
            "timeTaken" =>  (time() - $startTime),
            "path" => $path,
            "jobPath" => $jobPath
        ];
    }
    catch (Exception $ex) {

        $error = [
            "label" => $ex->getMessage(),
            "path" => $path,
            "jobPath" => $jobPath,
            "timeTaken" =>  (time() - $startTime),
            "file" => $ex->getFile(),
            "line" => $ex->getLine(),
            "trace" => $ex->getTrace()
        ];

    }
    finally {

        $connection->close();
    }
    
    if (!is_null($jobPath))
    {
        writeToDatabase(
            $credentials,
            $jobPath,
            $error
        );
    }

    echo json_encode(
        [
            "{Error}" => $error
        ]
    );
    
    return false;
    
}




function getPathByValueId(
    $connection,
    $valueId
)
{
    $sql = "SELECT getPathByValue(?) AS path;";

    $result = $connection->execute_query(
        $sql,
        [$valueId]
    );

    $data = $result->fetch_all(MYSQLI_ASSOC);

    return $data[0]["path"];
}

function getRootValueId($connection, $userId, & $lastType, $path)
{
    $lastType = null;
    
    $paths = explode('/', $path);
    
    $ownerId = null;
    
    if (count($paths) >= 2)
    {
        if ($paths[1] === 'my')
            $ownerId = $userId;
        else if (is_numeric($paths[1]))
            $ownerId = (int)($paths[1]);
    }
    else
        $ownerId = $userId;
        
    $statement = $connection->prepare(
      "CALL getRootValueId(?,?);"
    );

    $statement->bind_param(
        'ii', 
        $userId,
        $ownerId
    );

    $statement->execute();
    
    $statement->bind_result(
        $valueId,
        $lastType
    );
    
    if (!$statement->fetch())
        $valueId = null;

    $statement->close();
    
    
    return $valueId;
}


function _getValueIdByPath($connection, $credentials, $parentValueId, $insertLast, $lastType, & $lastPath, & $paths, & $errorIndex)
{
     
    $lastPath = null;
    
    $userId = $credentials["userId"];
    
    $statement = $connection->prepare(
      "CALL getValueIdByPath(?,?,?,?,?);"
    );
    

    $statement->bind_param(
        'iiiis', 
        $userId,
        $ownerId,
        $parentValueId,
        $pathIndex,
        $pathKey
    );
    
    if (count($paths) < 2)
        return null;

    if ($paths[1] === 'my')
        $ownerId = $userId;
    else if (is_numeric($paths[1]))
        $ownerId = (int)($paths[1]);
    else
        return null;
        
    $valueId = $parentValueId;
    
    $count = count($paths);
    

    for($i = 2; $i < $count; ++$i) {
        
        $segment = $paths[$i];
        
        if ($segment === "") {
            throw new PathException("Empty path", implode("/", $paths), $i);
        }
        
        $segment = decodePathSegment($segment);
        
        if (is_int($segment)) {
            $pathIndex = $segment;
            $pathKey = null;
        }
        else {
            $pathIndex = null;
            $pathKey = $segment;
        }
        
        $statement->execute();
    
        $statement->bind_result(
            $valueId,
            $type
        );
    

        
        if (!$statement->fetch()) {
            $statement->close();

            if ($i === ($count - 1) &&
                !is_numeric($segment) &&
                $insertLast &&
                ($lastType === "object" ||
                 $lastType === "array")
            )
            {
                $lastPath = $segment;
                $valueId = $parentValueId;
            }
            else {
                $errorIndex = $i;
                $valueId = null;
            }
            return $valueId;
        }
            
        $parentValueId = $valueId;
        $lastType = $type;
    }
    
    $statement->close();
    
    
    return $valueId;
}

// Most simple getValueIdByPath
function getValueIdByPath(
    $connection, 
    $credentials,
    $path
)
{
    $lastPath = null;
    return
        getValueIdByPathEx(
           $connection, 
           $credentials,
           false,
           $lastPath,
           $path
        );
    
}

// This is the extended version
// The use of lastPath is for
// Posts to append a key to
// an object. To use this feature
// you must set $insertLast to true
function getValueIdByPathEx(
    $connection, 
    $credentials,
    $insertLast,
    & $lastPath,
    $path
)
{
    $userId = $credentials["userId"];
    $paths = explode("/", $path);

    $rootValueId = getRootValueId(
        $connection,
        $userId,
        $lastType,
        $path
    );
    
    $pathValueId = null;
    $lastPath = null;
    $errorIndex = null;
    
    if (!is_null($rootValueId)) {
        
        $pathValueId = _getValueIdByPath(
            $connection,
            $credentials,
            $rootValueId, 
            $insertLast,
            $lastType,
            $lastPath,
            $paths,
            $errorIndex
        );
    }

    $found = false;
    if (!is_null($pathValueId))
        $found = true;
    else {
        if (is_null($rootValueId) &&
            $insertLast)
           $found = true;
    }
    
    if (!$found)
    {
        if (is_null($rootValueId))
            $i = 1;
        else
            $i = $errorIndex;
           
        $message = "Path not found";

        throw new PathException("Path not found", $path, $i);
        
    }

    if (is_null($pathValueId))
        return $rootValueId;
    
    return $pathValueId;
}

function pathExists(
    $connection, 
    $credentials,
    $path,
    $insertLast = true
)
{
    
    if ($path === "/my")
        return true;
        
    $valueId =
        getValueIdByPathEx(
            $connection, 
            $credentials,
            $insertLast,
            $lastPath,
            $path
        );
        
    return !is_null($valueId);
}

function getValueCount($stream) {
    $valueCountListener = new ValueCountListener();
    $valueCountParser = new \JsonStreamingParser\Parser(
        $stream,
        $valueCountListener
    );
    
    $valueCountParser->parse();
    
    if (!$valueCountListener->getResult())
        throw new Exception(
            "Unexpected end of data"
        );
                
    $totalValueCount =
        $valueCountListener->valueCount;
            
    return $totalValueCount;
}





function writeValuesToStream(
    $connection,
    $credentials,
    $path,
    $stream
)
{
    $pathValueId = null;

    $pathValueId =
        getValueIdByPathEx(
            $connection, 
            $credentials,
            false, // $insertLast
            $lastPath,
            $path
        );
   

    $rootStatement = $connection->prepare(
        "CALL getValuesById(?, ?);"
    );
    
    $ownerId =  $credentials["userId"];
    
    $values = loadValues(
        $rootStatement,
        $ownerId,
        $pathValueId
    );
     
    $rootStatement->close();
    
    $statement = $connection->prepare(
        "CALL getValuesByParentId(?, ?);"
    );
    

    printValues(
        $stream,
        $statement, 
        $ownerId,
        $values
    );
    
}

function handleSearch($query)
{
    $credentials = authenticate();
    $connection = getConnection();

    
    $sql = <<<END
select distinct
    getPathByValue(v.valueId, ?) as path
from 
    Value as v
where
    v.parentValueId = ?
and
    v.locked = 0

END;

    $lastPath = null;
    
    $pathValueId = getValueIdByPathEx(
        $connection,
        $credentials,
        false,
        $lastPath,
        getPath(),
        true
    );

    $words = explode("+", $query);

    $wordCount = count($words);
    for ($i = 0; $i < $wordCount; ++$i) {
        $word = $words[$i];
        $words[$i] = decodePathSegment($word);
        $sql =
            $sql .
            "and\r\n" .
            word();
    }
    

    $sql = $sql . "limit 100";
    
    $parameters =
        array_merge(
            [$credentials["userId"]],
            [$pathValueId],
            $words
        );


    $result = $connection->execute_query(
        $sql,
        $parameters
    );
    
    $data = $result->fetch_all(MYSQLI_ASSOC);
    
    http_response_code(200);
    
    header('Content-Type: application/json; charset=utf-8');
      
    setCredentialsCookie($credentials);
    
    $count = count($data);

    echo "[\r\n";
    
    for ($i = 0; $i < $count; ++$i) {
        $row = $data[$i];
        $path = $row["path"];
        
        echo tabs(1)
            . '"' . $path . '"';
            
        if ($i + 1 < $count)
           echo ",";
           
        echo "\r\n";
    }
    
    echo "]";
    
    $connection->close();

    // Log this query
    /*
    writeToDatabase(
       $credentials,
       '/my/queries/[]',
       urldecode($query)
    );
*/
    
}

function word() {
    $sql = <<<END
    exists(
        select
            vw.valueId as valueId
        from
            ValueWord as vw,
            Word as w
        where
            w.word = ?
        and
            vw.valueId = v.valueId
        and
            vw.wordId = w.wordId
            
    )

END;

   return $sql;
}
    
function printValues(
    $stream,
    $statement, 
    $ownerId, 
    $values,
    $tabCount = 0, 
    $isFirst = true
)
{
     
    $counter = 0;
    $valueCount = count($values);
    
    foreach ($values as $value)
    {
        $valueId = $value['valueId'];
        $type = $value['type'];
        $locked = $value['locked'];
        $objectKey = $value['objectKey'];
        $objectIndex = $value['objectIndex'];
        $isNull = $value['isNull'];
        $numericValue = $value['numericValue'];
        $stringValue = $value['stringValue'];
        $boolValue = $value['boolValue'];
        $childCount = $value["childCount"];
        $isEmpty = ($childCount === 0);
        $isLast = (++$counter === $valueCount);

        if ($locked)
            $type = "null";

        fwrite($stream, tabs($tabCount));
        
        // Write object key
        if (!$isFirst && !is_null($objectKey))
        {
            fwrite($stream, encodeString($objectKey)
                 . ': ');
        }
        
        $isFirst = false;
        
        switch ($type) {
        case "null":
            fwrite($stream, "null");
            break;
        case "object":

            fwrite($stream, "{");

            if (!$isEmpty) {
                printChildValues(
                    $stream,
                    $statement,
                    $ownerId,
                    $valueId,
                    $tabCount,
                    $isFirst
                );
            }
            
            fwrite($stream, "}");
                 
                 
            break;
            
        case "array":
            fwrite($stream, "[");
            if (!$isEmpty) {
                printChildValues(
                    $stream,
                    $statement,
                    $ownerId,
                    $valueId,
                    $tabCount,
                    $isFirst
                );
            }
            fwrite($stream, "]");
            break;
        case "string":
            fwrite($stream,
                encodeString($stringValue)
            );
            break;
        case "number":
            fwrite($stream, $numericValue);
            break;
        case "bool":
            if ($boolValue)
                fwrite($stream, 'true');
            else
                fwrite($stream, 'false');
            break;
        
        }
     
        
        
        // Write array or key seperator
        if (!$isLast)
        {
            fwrite($stream, ",");
            fwrite($stream, "\r\n");
        }
            
    }
        

}

function printChildValues(
    $stream,
    $statement,
    $ownerId,
    $valueId,
    $tabCount,
    $isFirst
)
{
     fwrite($stream, "\r\n");
                
     $childValues = loadValues(
         $statement,
         $ownerId,
         $valueId
     );
     
     // Print this child
     printValues(
          $stream,
          $statement,
          $ownerId,
          $childValues,
          $tabCount + 1,
          $isFirst
     );
            
     fwrite($stream, "\r\n" . tabs($tabCount));
                
}
  
function loadValues($statement, $ownerId, $parentValueId) {
    $statement->bind_param(
        'ii', 
        $ownerId,
        $parentValueId
    );
        
    $statement->execute();
        

    $values = [];
     
    $result = $statement->get_result();
     
    while ($row = $result->fetch_assoc()) {
        $values[] = $row;
    }
     
    return $values;
}

function tabs($tabCount) {
    return str_repeat("   ", $tabCount);
}
    

?>