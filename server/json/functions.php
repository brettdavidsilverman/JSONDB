<?php

require_once 'JSONDBListener.php';
require_once 'ValueCountListener.php';

function getRootValueId($connection, $userId)
{
    $path = getPath();
    
    $paths = explode('/', $path);

    $ownerId = null;
    
    if (!empty($paths))
    {
        if ($paths[0] === 'my')
            $ownerId = $userId;
        else if (is_numeric($paths[0]))
            $ownerId = (int)($paths[0]);
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

function _getValueByPath($connection, $userId, $parentValueId, & $paths)
{
     
    $statement = $connection->prepare(
      "CALL getValueByPath(?,?,?,?,?);"
    );
    

    $statement->bind_param(
        'iiiis', 
        $userId,
        $ownerId,
        $parentValueId,
        $pathIndex,
        $pathKey
    );
    
    if (empty($paths))
        return null;

    $first = array_shift($paths);
    if ($first === "my")
        $ownerId = $userId;
    else if (is_numeric($first))
        $ownerId = (int)($first);
     
    $valueId = $parentValueId;
    
    $count = 0;
    
    foreach ($paths as $path) {
        $valueId = null;
                
        $count++;
        $path = urldecode($path);
        
        if ($path === "")
            continue;
            

        if (is_numeric($path)) {
            $pathIndex = (int)($path);
            $pathKey = null;
        }
        else {
            $pathIndex = null;
            $pathKey = strtolower($path);
        }
        
        $statement->execute();
    
        $statement->bind_result(
            $valueId
        );
    
        if (!$statement->fetch()) {
            array_unshift($paths, $first);
            $paths[$count] = "{" . $path . "}";
            $valueId = null;
            break;
        }
            
        $parentValueId = $valueId;
    }
    
    $statement->close();
    
    
    return $valueId;
}

function getValueByPath($connection, $credentials)
{
    $userId = $credentials["userId"];

    $rootValueId = getRootValueId($connection, $userId);
        
    $path = getPath();
    $paths = explode("/", $path);
        
    $pathValueId = _getValueByPath($connection, $userId, $rootValueId, $paths);
    
    if (is_null($pathValueId)) {
        http_response_code(404);
        setCredentialsCookie($credentials);
        header('Content-Type: application/json; charset=utf-8');
        $error = "🛑 Path " . join("/", $paths) . " not found";
        echo encodeString($error);
        exit();
    }
        
        
    return $pathValueId;
}


function handlePost($connection, $file = null)
{

    $start = time();

    $credentials = authenticate(true);

    $pathValueId = getValueByPath($connection, $credentials);
    
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
        $listener = new ValueCountListener();
        $parser = new \JsonStreamingParser\Parser($stream, $listener);
        $parser->parse();
        if (!$listener->getResult())
            throw new Exception(
                "Unexpected end of data"
            );
                
        $totalValueCount =
            $listener->valueCount;
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
        
    rewind($stream);
    setSessionStatus(
        $credentials,
        [
            "label" => "Indexing...",
            "percentage" => 0,
            "done" => false
        ]
    );
        

    try {
        $listener = new JSONDBListener($connection, $credentials, $pathValueId, $totalValueCount);
        $parser = new \JsonStreamingParser\Parser($stream, $listener);
        $parser->parse();
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
    finally {
        fclose($stream);
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
    
    $pathValueId = getValueByPath($connection, $credentials);
    
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