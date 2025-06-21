<?php

require_once 'JSONDBListener.php';
require_once 'ValueCountListener.php';

function readFromDatabase(
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
        $stream
    );

    if (!$returnObject)
        return;
        
    rewind($stream);
    
    $string =
        stream_get_contents($stream);
    
    return json_decode($string);

}

function writeToDatabaseEx(
    $connection,
    $credentials,
    $path,
    $object = null,
    $stream = null,
    $log = false,
    & $jobPath
)
{
    
    $listener = new JSONDBListener(
        $connection,
        $credentials,
        $path,
        $object,
        $stream,
        $log
    );
        
    try {
       $newPath =
          $listener->writeToDatabase();
  
    }
    catch (Exception $e) {

        writeToDatabase(
            $credentials,
            $listener->jobPath,
            [
                "label" => $e->getMessage(),
                "percentage" => 0,
                "done" => true,
                "error" =>
                    $e->getTraceAsString()
            ]
        );
    
            
        echo encodeString($e->getMessage());
            
        return false;
            
    }
    
    $jobPath = $listener->jobPath;
    
    
    return $newPath;
    
}

function writeToDatabase(
    $credentials,
    $path,
    $status,
    $insertLast = true
)
{
    $connection = getConnection();
    $result = null;
    
    if (pathExists(
           $connection,
           $credentials,
           $path,
           $insertLast
        )
    )
    {
        $result = writeToDatabaseEx(
            $connection,
            $credentials,
            $path,
            $status,
            null,
            false,
            $jobPath
        );
    }
    
    $connection->close();
    
    return $result;
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
    readFromDatabase(
        $connection,
        $credentials,
        $path,
        $stream,
        false
    );
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
        
    $stream = fopen($file, 'r');
    $path = getPath();
    
    
    // Parse stream into database
    $newPath = writeToDatabaseEx(
        $connection,
        $credentials,
        $path,
        null,
        $stream,
        true,
        $jobPath
    );

    $result = encodeString($newPath);

    echo $result;
    
          
    $end = time();
        
    $timeTaken = $end - $start;
        
    writeToDatabase(
        $credentials,
        $jobPath,
        [
            "label" => "Finished writing $path ✅",
            "percentage" => 0,
            "timeTaken" => $timeTaken,
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
// If $returnError is set and the
// path doesnt exist, this sets
// the error code to 404 and exits
// with a formatted error description.
// If $returnValue is false and the
// path doesnt exist, this returns null
function getValueIdByPath(
    $connection, 
    $credentials,
    $path,
    $returnError = false
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
           $returnError
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
    $path,
    $returnError = true
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
    
    if ($returnError &&
        is_null($pathValueId) &&
        count($paths) > 2)
    {
        if (is_null($rootValueId))
           $paths[1] = "{" . $paths[1] . "}";
           
        http_response_code(404);
        setCredentialsCookie($credentials);
        header('Content-Type: application/text');
        $error = "🛑 Path " . join("/", $paths) . " not found";
        echo encodeString($error);
        exit();
    }
    
    return $pathValueId;
}

function pathExists(
    $connection, 
    $credentials,
    $path,
    $ignoreLast = false
)
{
    $valueId =
        getValueIdByPathEx(
            $connection, 
            $credentials,
            $ignoreLast, //$insertLast,
            $lastPath,
            $path,
            false //$returnError = true
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
    $stream
)
{
    $pathValueId = getValueIdByPath(
        $connection,
        $credentials,
        getPath(),
        true
    );
    
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
    writeToDatabase(
       $credentials,
       '/my/queries/[]',
       urldecode($query)
    );

    
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