<?php

require_once 'JSONDBListener.php';
require_once 'ValueCountListener.php';

function readFromDatabase(
    $credentials,
    $path
)
{
    $connection = getConnection();
    
    $result = readFromDatabaseEx(
        $connection,
        $credentials,
        $path,
        null,
        true
    );
    
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
    
    writeValues(
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
    
    return json_decode($string);

}

function writeToDatabase(
    $credentials,
    $path,
    $object
)
{
    if (is_null($path))
       return null;
       
    
    $connection = getConnection();
    $result = null;
    $listener = null;
    
    try {
    
        $result = writeToDatabaseEx(
            $connection,
            $credentials,
            $path,
            $object,
            null, //$stream
            false, //$log
            $listener,
            true, //$throwOnInvalidPath,
            null //$jobPath
        );
    
    }
    catch (Exception $ex) {
        $result = null;
    }
    
    $connection->close();
    
    return $result;
}

function writeToDatabaseEx(
    $connection,
    $credentials,
    $path,
    $object = null,
    $stream = null,
    $log = true,
    & $listener,
    $throwOnInvalidPath,
    $jobPath
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
        $log,
        true, //$throwOnInvalidPath,
        $jobPath
    );
    
    $listener->writeToDatabase();
          
    return $listener->newPath;
    
}



function handleGet($connection)
{
    $credentials = authenticate();

    http_response_code(200);
    
    header('Content-Type: application/json');
      
    setCredentialsCookie($credentials);
    
    $stream = fopen("php://output", "w");
    $path = getPath();
    
    /*
    if ($path != "/my/status")
        writeToDatabase(
            $credentials,
            "/my/status",
            [
                "label" => "Reading $path ...",
                "percentage" => 0,
                "done" => false
            ]
        );
    
    */
    try {
        readFromDatabaseEx(
            $connection,
            $credentials,
            $path,
            $stream,
            false
        );
    }
    catch (Exception $ex) {
        echo json_encode(
            [
               '"{Error}"' => [
                  "message" => $ex->getMessage()
               ]
            ]
        );
        
    }
    
    /*
    if ($path != "/my/status")
        writeToDatabase(
            $credentials,
            "/my/status",
            [
                "label" => "Reading $path ✅",
                "percentage" => 0,
                "done" => true
            ]
        );
    
*/
}

function handlePost($connection, $file = null)
{

    $start = time();

    $credentials = authenticate(true);
    

    http_response_code(200);
    setCredentialsCookie($credentials);
        
    
    header('Content-Type: application/json');
     
    if (is_null($file))
        $file = 'php://input';
        
    $inputStream = fopen($file, 'r');
    $path = getPath();
    $inError = false;
    $listener = null;
    
    $jobPath =
        writeToDatabase(
            $credentials,
            "/my/jobs/[]",
            [
                "message" => "Indexing...",
                "path" => $path,
                "progress" => 0,
                "cancel" => false,
                "done" => false
            ]
        );
        
    
    try {
        // Parse stream into database
        writeToDatabaseEx(
            $connection,
            $credentials,
            $path,
            null, //$object
            $inputStream,
            true, //$log
            $listener,
            true, //$throwOnInvalidPath
            $jobPath
        );

    }
    catch (Exception $ex) {
        

        $error = [
            "message" => $ex->getMessage(),
            "timeTaken" =>  (time() - $start),
            "path" => $path,
            "timeTaken" =>  (time() - $start),
            "stack" => $ex->getTraceAsString()
        ];
        
        
        writeToDatabase(
            $credentials,
            $jobPath,
            $error
        );
    
        echo json_encode(
            [
                "{Error}" => $error
            ]
        );
        
        return false;
    }
    
    
    $newPath = $listener->newPath;
    
    if (is_null($newPath))
        echo "undefined";
    else {
        $result =
            json_encode($newPath);
    
        echo $result;
    }
    
    writeToDatabase(
        $credentials,
        $jobPath,
        [
            "message" => "Success",
            "path" => $path,
            "newPath" => $listener->newPath,
            "jobPath" => $jobPath,
            "timeTaken" =>  (time() - $start),
            "done" => true
        ]
    );

    return true;
            
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


function _getValueIdByPath($connection, $credentials, $parentValueId, $insertLast, $lastType, & $lastPath, & $paths)
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
        
        $path = $paths[$i];
        
        if ($path === "")
            continue;
            
        $path = urldecode($path);
        


        if (is_numeric($path)) {
            $pathIndex = (int)($path);
            $pathKey = null;
        }
        else {
            $pathIndex = null;
            $pathKey = $path;
        }
        
        $statement->execute();
    
        $statement->bind_result(
            $valueId,
            $type
        );
    

        
        if (!$statement->fetch()) {
            $statement->close();

            if ($i === ($count - 1) &&
                !is_numeric($path) &&
                $insertLast &&
                ($lastType === "object" ||
                 $lastType === "array")
            )
            {
                $lastPath = $path;
                $valueId = $parentValueId;
            }
            else {
                $paths[$i] = "{" . urldecode($path) . "}";
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
// If $throwOnInvalidPath is set and the
// path doesnt exist, this sets
// the error code to 404 and exits
// with a formatted error description.
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
           $path,
           true //$throwOnInvalidPath
        );
    
}

// This is the extended version
// The use of lastPath is for
// Posts to append a key to
// an object. To use this feature
// you must set $insertLast to true
// If $throwOnInvalidPath is false and the
// path doesnt exist, this returns null
// Note that for new users /my also
// returns null
function getValueIdByPathEx(
    $connection, 
    $credentials,
    $insertLast,
    & $lastPath,
    $path,
    $throwOnInvalidPath
)
{
    $userId = $credentials["userId"];

    $rootValueId = getRootValueId(
        $connection,
        $userId,
        $lastType,
        $path
    );
    

    $pathValueId = null;
    
    $paths = explode("/", $path);
    $lastPath = null;
    
    if (!is_null($rootValueId)) {
        
        $pathValueId = _getValueIdByPath(
            $connection,
            $credentials,
            $rootValueId, 
            $insertLast,
            $lastType,
            $lastPath,
            $paths
        );
    }
    
    if ($throwOnInvalidPath &&
        is_null($pathValueId) &&
        !(
            $path === "my" ||
            $path === "/my" ||
            $path === "my/" ||
            $path === "/my/"
        )
    )
    {
        if (is_null($rootValueId))
           $paths[1] = "{" . $paths[1] . "}";
           
        $path = implode("/", $paths);
        /*
        $error = [
           "message" => "Path not found",
           "status" => 404,
           "path" => $path,
           "where" => "server/json/functions/getValueIdByPathEx"
        ];
        
        $message = json_encode($error);
        */
        
        $message = "Path not found " . $path;
        
        throw new Exception($message);
        
        exit();
    }
    
    return $pathValueId;
}

function pathExists(
    $connection, 
    $credentials,
    $path,
    $insertLast = true
)
{
    
    if ($path === "my"  ||
        $path === "/my" ||
        $path === "my/" ||
        $path === "/my/")
        return true;
        
    $valueId =
        getValueIdByPathEx(
            $connection, 
            $credentials,
            $insertLast,
            $lastPath,
            $path,
            false//$returnError = true
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





function writeValues(
    $connection,
    $credentials,
    $path,
    $stream
)
{
    $pathValueId =
        getValueIdByPathEx(
           $connection, 
           $credentials,
           false,
           $lastPath,
           $path,
           false //$throwOnInvalidPath
        );
        
    if (is_null($pathValueId)) {
       fwrite($stream, "undefined");
       return;
    }
        /*
    $pathValueId = getValueIdByPath(
        $connection,
        $credentials,
        $path,
        true
    );
    */
    $rootStatement = $connection->prepare(
        "CALL getValuesById(?);"
    );
    
    $values = loadValues($rootStatement, $pathValueId);
     
    $rootStatement->close();
    
    $statement = $connection->prepare(
        "CALL getValuesByParentId(?);"
    );
    

    printValues($stream, $statement, $values);
    
}

function handleSearch($connection)
{
    $credentials = authenticate();
    
    $query = getQuery();
    
    $sql = <<<END
select distinct
    getPathByValue(v.valueId) as path
from 
    Value as v
inner join
    ValueParentChild as vpc
on
    vpc.parentValueId = ?
and
    vpc.childValueId = v.valueId
where
    v.jobId is null

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
        $words[$i] = urldecode($word);
        $sql =
            $sql .
            "and\r\n" .
            word();
    }
    

    $sql = $sql . "limit 100";
    
    $parameters =
        array_merge(
            [$pathValueId],
            $words
        );


    $result = $connection->execute_query(
        $sql,
        $parameters
    );
    
    $data = $result->fetch_all(MYSQLI_ASSOC);
    
    http_response_code(200);
    
    header('Content-Type: application/json');
      
    setCredentialsCookie($credentials);
    
    $count = count($data);

    echo "[\r\n";
    
    for ($i = 0; $i < $count; ++$i) {
        $row = $data[$i];
        $path = $row["path"];
        $paths = explode("/", $path);
        $stringPath = "";
        foreach ($paths as $segment)
        {
            $stringPath =
                $stringPath
                . escapeString($segment)
                . "/";
        }
        
        $stringPath =
            substr($stringPath, 0, -1);
        
        echo tabs(1)
            . '"' . $stringPath . '"';
            
        if ($i + 1 < $count)
           echo ",";
           
        echo "\r\n";
    }
    
    echo "]";
    
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
            Word as w,
            ValueParentChild as vpc
        where
            w.word = ?
        and
            vw.valueId = vpc.childValueId
        and
            vw.wordId = w.wordId
        and
            vpc.parentValueId = v.valueId
            
    )

END;

   return $sql;
}
    
function printValues($stream, $statement, $values, $tabCount = 0, $isFirst = true) {
     
    $counter = 0;
    $valueCount = count($values);
    
    foreach ($values as $value)
    {
        $valueId = $value['valueId'];
        $type = $value['type'];
        $objectKey = $value['objectKey'];
        $objectIndex = $value['objectIndex'];
        $isNull = $value['isNull'];
        $numericValue = $value['numericValue'];
        $stringValue = $value['stringValue'];
        $boolValue = $value['boolValue'];
        $childCount = $value["childCount"];
        $isEmpty = ($childCount === 0);
        $isLast = (++$counter === $valueCount);

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
    $valueId,
    $tabCount,
    $isFirst
)
{
     fwrite($stream, "\r\n");
                
     $childValues = loadValues(
         $statement,
         $valueId
     );
     
     // Print this child
     printValues(
          $stream,
          $statement,
          $childValues,
          $tabCount + 1,
          $isFirst
     );
            
     fwrite($stream, "\r\n" . tabs($tabCount));
                
}
  
function loadValues($statement, $parentValueId) {
    $statement->bind_param(
        'i', 
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