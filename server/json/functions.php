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

function getValueByPath($connection, $userId, $parentObjectId, & $paths)
{
     
    $statement = $connection->prepare(
      "CALL getValueByPath(?,?,?,?,?);"
    );
    

    $statement->bind_param(
        'iiiis', 
        $userId,
        $ownerId,
        $parentObjectId,
        $pathIndex,
        $pathKey
    );
    
    //$userId = $_SESSION['userId'];
    
    if (empty($paths))
        return null;

    $first = array_shift($paths);
    if ($first === "my")
        $ownerId = $userId;
    else if (is_numeric($first))
        $ownerId = (int)($first);
     
    $valueId = null;
    $count = 0;
    
    foreach ($paths as $path) {
         
        $count++;
        $path = urldecode($path);
        
        if ($path === "")
            continue;
            
        $valueId = null;
         
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
            $objectId,
            $valueId
        );
    
        if (!$statement->fetch()) {
            array_unshift($paths, $first);
            $paths[$count] = "{" . $path . "}";
            $objectId = null;
            $valueId = null;
            break;
        }
            
        $parentObjectId = $objectId;
    }
    
    $statement->close();
    
    
    
    return $valueId;
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
      
    setSessionStatus($credentials, "Validating...", 4.0, false);
        
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
            $e->getMessage(),
            0,
            true
        );
            
        echo "false";
            
        return false;
            
    }
        
    rewind($stream);
    setSessionStatus(
        $credentials,
        "Indexing...",
         0,
         false
    );
        
    try {
        $listener = new JSONDBListener($connection, $credentials, $totalValueCount);
        $parser = new \JsonStreamingParser\Parser($stream, $listener);
        $parser->parse();
    }
    catch (Exception $e) {
        throw $e;
    }
    finally {
        fclose($stream);
    }
        

    $end = time();
        
    $timeTaken = $end - $start;
        
    setSessionStatus(
        $credentials,
        "⏰ Finished in " . $timeTaken . " seconds",
        0,
        true
    );
        
    echo "true";
    
    return true;
            
}
    
function handleGet($connection)
{
    $credentials = authenticate();
    
    $userId = $credentials["userId"];

    $valueId = null;
    $rootValueId = getRootValueId($connection, $userId);
        
    $path = getPath();
    $paths = explode("/", $path);
        

    if (count($paths) > 1) {
        $valueId = getValueByPath($connection, $userId, $rootValueId, $paths);

        if (is_null($valueId)) {
            http_response_code(404);
            setCredentialsCookie($credentials);
            header('Content-Type: text/plain');
            echo "🛑 Path " . join("/", $paths) . " not found\r\n";
            return false;
        }

    }
    else
        $valueId = $rootValueId;
        
    http_response_code(200);
    
    
    header('Content-Type: application/json');
      
    setCredentialsCookie($credentials);
    
    $rootStatement = $connection->prepare(
        "CALL getValuesById(?);"
    );
    
    $values = loadValues($rootStatement, $valueId);
     
    $rootStatement->close();
    
    $statement = $connection->prepare(
        "CALL getValuesByParentId(?);"
    );

    printValues($statement, $values);
        
        
}
    
function printValues($statement, $values, $tabCount = 0) {
     
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
        if (!is_null($objectKey))
        {
            echo encodeString($objectKey)
                 . ': ';
        }
        
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
                    $tabCount
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
                    $tabCount
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
    $tabCount
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
          $tabCount + 1
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