<?php

require_once 'JSONDBListener.php';
require_once 'ValueCountListener.php';

function getRootValueId($connection, $userId, $path)
{

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
        $valueId
    );
    
    if (!$statement->fetch())
        $valueId = null;

    $statement->close();
    
    
    return $valueId;
}

function insertLastValue(
    $connection,
    $credentials,
    $parentValueId,
    $path
)
{
    $statement = $connection->prepare(
        "CALL insertLastValue(?,?,?);"
    );
    
    $sessionKey = $credentials["sessionKey"];
    
    $statement->bind_param(
        'sis', 
        $sessionKey,
        $parentValueId,
        $path
    );
    
    $statement->execute();
    
    $statement->bind_result(
        $valueId
    );
    
    if (!$statement->fetch())
        $valueId = null;

    $statement->close();
    

    return $valueId;
}

function _getValueIdByPath($connection, $credentials, $parentValueId, $insertLast, & $lastPath, & $paths)
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
        
        $path = urldecode($path);
        
        if ($path === "")
            continue;
            
        
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
            $valueId
        );
    

        
        if (!$statement->fetch()) {
            $statement->close();

            if ($i === ($count - 1) &&
                !is_numeric($path) &&
                $insertLast
            )
            {
                $lastPath = $path;
                $valueId = $parentValueId;
                /*
                $valueId = insertLastValue(
                    $connection,
                    $credentials,
                    $parentValueId,
                    $path
                );
                */
            }
            else {
                $paths[$i] = "{" . urldecode($path) . "}";
                $valueId = null;
            }
            return $valueId;
        }
            
        $parentValueId = $valueId;
    }
    
    $statement->close();
    
    
    return $valueId;
}

function getValueIdByPath(
    $connection, 
    $credentials,
    $insertLast,
    & $lastPath,
    $path
)
{
    $userId = $credentials["userId"];

    $rootValueId = getRootValueId(
        $connection,
        $userId,
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
            $lastPath,
            $paths
        );
    }
    
    if (is_null($pathValueId) &&
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

function insertIntoDatabase(
    $connection,
    $credentials,
    $totalValueCount,
    $stream
)
{
      
    setSessionStatus(
        $credentials,
        [
            "label" => "Indexing...",
            "percentage" => 0,
            "done" => false
        ]
    );
    
    $lastPath = null;
    
    $pathValueId = getValueIdByPath(
        $connection,
        $credentials,
        true,
        $lastPath,
        getPath()
    );
    
    
        
    $listener = new JSONDBListener(
        $connection,
        $credentials,
        $pathValueId,
        $lastPath,
        $totalValueCount
    );
        
    $parser = new \JsonStreamingParser\Parser(
        $stream,
        $listener
    );
        
    $parser->parse();
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
    

    $totalValueCount = null;
      
    setSessionStatus($credentials,
        [
            "label" => "Validating...",
            "percentage" => 4.0,
            "done" => false
        ]
    );
        
    try {
        // Get the count of posted values
        $totalValueCount =
            getValueCount($stream);
            
        // Reset the stream to start inserting
        rewind($stream);
      
        // Parse stream into database
        insertIntoDatabase(
            $connection,
            $credentials,
            $totalValueCount,
            $stream
        );
        
        
    }
    catch (Exception $e) {
             
        setSessionStatus(
            $credentials,
            [
                "label" => $e->getMessage(),
                "percentage" => 0,
                "done" => true
            ]
        );
            
        echo "false";
            
        return false;
            
    }
        
    $end = time();
        
    $timeTaken = $end - $start;
        
    setSessionStatus(
        $credentials,
        [
            "label" => "⏰ Finished in " . $timeTaken . " seconds",
            "percentage" => 0,
            "done" => true
        ]
    );
        
    echo "true";
    
    return true;
            
}
    
function handleGet($connection)
{
    $credentials = authenticate();
    $lastPath = null;
    
    $pathValueId = getValueIdByPath(
        $connection,
        $credentials,
        false,
        $lastPath,
        getPath()
    );
    
    http_response_code(200);
    
    header('Content-Type: application/json');
      
    setCredentialsCookie($credentials);
    
    $rootStatement = $connection->prepare(
        "CALL getValuesById(?);"
    );
    
    $values = loadValues($rootStatement, $pathValueId);
     
    $rootStatement->close();
    
    $statement = $connection->prepare(
        "CALL getValuesByParentId(?);"
    );

    printValues($statement, $values);
        
    //printChildValues($statement, $valueId);
}

function handleSearch($connection)
{
    $credentials = authenticate();
    
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
    v.sessionId is null

END;

    $lastPath = null;
    
    $pathValueId = getValueIdByPath(
        $connection,
        $credentials,
        false,
        $lastPath,
        getPath()
    );
    
    $words = explode("+", getQuery());
    $wordCount = count($words);
    for ($i = 0; $i < $wordCount; ++$i) {
        $word = $words[$i];
        $words[$i] = urldecode($word);
        $sql = $sql . "and\r\n" . word();
    }

    $sql = $sql . "limit 10";
    
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
    
function printValues($statement, $values, $tabCount = 0, $isFirst = true) {
     
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

        echo tabs($tabCount);
        
        // Write object key
        if (!$isFirst && !is_null($objectKey))
        {
            echo encodeString($objectKey)
                 . ': ';
        }
        
        $isFirst = false;
        
        switch ($type) {
        case "null":
            echo "null";
            break;
        case "object":

            echo "{";

            if (!$isEmpty) {
                printChildValues(
                    $statement,
                    $valueId,
                    $tabCount,
                    $isFirst
                );
            }
            
            echo "}";
                 
                 
            break;
            
        case "array":
            echo "[";
            if (!$isEmpty) {
                printChildValues(
                    $statement,
                    $valueId,
                    $tabCount,
                    $isFirst
                );
            }
            echo "]";
            break;
        case "string":
            echo encodeString($stringValue);
            break;
        case "number":
            echo $numericValue;
            break;
        case "bool":
            if ($boolValue)
                echo 'true';
            else
                echo 'false';
            break;
        
        }
     
        
        
        // Write array or key seperator
        if (!$isLast)
        {
            echo ",";
            echo "\r\n";
        }
            
    }
        

}

function printChildValues(
    $statement,
    $valueId,
    $tabCount,
    $isFirst
)
{
     echo "\r\n";
                
     $childValues = loadValues(
         $statement,
         $valueId
     );
     
     // Print this child
     printValues(
          $statement,
          $childValues,
          $tabCount + 1,
          $isFirst
     );
            
     echo "\r\n" . tabs($tabCount);
                
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