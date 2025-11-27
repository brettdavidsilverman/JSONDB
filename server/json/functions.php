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
        
        if (!is_null($listener))
            $listener->cancelDocument();
            
        parent::__construct("Cancelled");
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


function handleGet($credentials)
{

    
    $type = "application/json; charset=utf-8";
    if (array_key_exists("type", $_GET))
    {
        if ($_GET["type"] === "text")
           $type = "text/plain; charset=utf-8";
    }
    
    header("Content-Type: " . $type);
      

    
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
            "path" => $path
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

function handlePost($credentials)
{

         
    
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
        if (!is_null($error))
        
            $listener->cancelDocument();
            
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
    $valueId,
    $userId
)
{
    $sql = "SELECT getPathByValue(?, ?) AS path;";

    $result = $connection->execute_query(
        $sql,
        [$valueId, $userId]
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


function _getValueIdByPath($connection, $credentials, $parentValueId, $lastType, & $lastPath, & $path, & $errorIndex)
{
    $paths = explode("/", $path);
         
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
        
        if (strlen($segment) === 0) {
            throw new PathException("Empty path", $path, $i);
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
                $segment === "$" &&
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
// getting count of values per valueId
function getValueIdByPathEx(
    $connection, 
    $credentials,
    & $lastPath,
    $path
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
    $lastPath = null;
    $errorIndex = null;
    
    if (!is_null($rootValueId)) {
        
        $pathValueId = _getValueIdByPath(
            $connection,
            $credentials,
            $rootValueId, 
            $lastType,
            $lastPath,
            $path,
            $errorIndex
        );
    }

    $found = false;
    if (!is_null($pathValueId))
        $found = true;
    else {
        $found = false;
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
    $path
)
{
    
    if ($path === "/my")
        return true;
        
    $valueId =
        getValueIdByPathEx(
            $connection, 
            $credentials,
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
            $lastPath,
            $path
        );
   

    if ($lastPath === "$") {
        writeCountByParentId($connection, $credentials, $pathValueId, $stream);
        return;
    }
    
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

function writeCountByParentId(
    $connection, 
    $credentials,
    $parentValueId, 
    $stream
)
{
    $statement = $connection->prepare(
        "CALL getCountByParentValueId(?, ?);"
    );
    
    $userId =  $credentials["userId"];
    
    $statement->bind_param(
        'ii', 
        $userId,
        $parentValueId
    );
        
    $statement->execute();
        
    $statement->bind_result(
        $count
    );
    
    if (!$statement->fetch())
        $count = null;
        
    if (!is_null($stream)) {
        if (!is_null($count))
            fwrite($stream, $count);
        else
            fwrite($stream, "null");
    }
    
    return $count;
}
    

function handleSearch($credentials, $query)
{
    
    header('Content-Type: application/json; charset=utf-8');
      
    
    $connection = getConnection();

    
    $sql = <<<END
with
    matches as (
        select
            v.valueId
        from
            Value as v
        inner join
            ValueParentChild as vpc
        on
            vpc.childValueId = v.valueId

END;

    $lastPath = null;
    
    try {
        $pathValueId = getValueIdByPathEx(
            $connection,
            $credentials,
            $lastPath,
            getPath(),
            true
        );
    }
    catch (PathException $ex) {
        
        $error = [
            "label" => $ex->getMessage(),
            "path" => $ex->path
        ];
        
        echo json_encode(
            [
                "{Error}" => $error
            ]
        );
    
        return false;
        
    }

    $words = explode("+", $query);

    $wordCount = count($words);
    for ($i = 0; $i < $wordCount; ++$i) {
        $word = $words[$i];
        $words[$i] = decodePathSegment($word);
        $alias = "w" . $i;
        $sql =
            $sql .
            word($alias);
    }
    
    $fromRow = 1;
    if (array_key_exists("fromRow", $_GET) &&
        is_numeric($_GET["fromRow"]))
    {
        $fromRow = (int)($_GET["fromRow"]);
    }
    
    $toRow = 100;
    if (array_key_exists("toRow", $_GET))
        
    {
        if ($_GET["toRow"] === "$")
            $toRow = null;
        else if (is_numeric($_GET["toRow"]))
            $toRow = (int)($_GET["toRow"]);
    }

    $sql = $sql . <<<END
        where
            vpc.parentValueId = ?
        and
            not exists(
                select
                    *
                from
                    Value
                inner join
                    ValueParentChild as vpc
                on
                    vpc.parentValueId = Value.valueId
                and
                    vpc.childValueId = v.valueId
                where
                    Value.locked = 1
                or
                    Value.locked is null
            )
    ),
    rowedMatches as (
        select
            matches.*,
            row_number() over 
                (order by matches.valueId )
                as rowNumber
        from
            matches
    )
select
    (
        select
            count(*)
        from
            rowedMatches
    ) as totalCount,
    getPathByValue (
        valueId,
        ?
    ) as path

from
    rowedMatches

where

END;


    if (!is_null($toRow)) {
        $sql = $sql . <<<END
    rowNumber between $fromRow and $toRow;

END;
    }
    else {
        $sql = $sql . <<<END
    rowNumber >= $fromRow;

END;
    }


    if (array_key_exists("type", $_GET) &&
        $_GET["type"] === "sql")
    {
        echo $sql;
        return true;
    }

    $parameters =
        array_merge(
            $words,
            [$pathValueId],
            [$credentials["userId"]]
        );


    $result = $connection->execute_query(
        $sql,
        $parameters
    );
    

    $data = $result->fetch_all(MYSQLI_ASSOC);
    
    $connection->close();
    
    $count = count($data);
    
    $totalRows = 0;
    
    if ($count > 0)
        $totalRows = $data[0]["totalCount"];
    else
        $fromRow = 0;
    
    
    if (is_null($toRow) ||
       $toRow >= $totalRows)
    {
        $toRow = $totalRows;
    }
    
    echo <<<END
{
    "fromRow": $fromRow,
    "toRow": $toRow,
    "totalRows": $totalRows,
    "paths": [

END;

    
    for ($i = 0; $i < $count; ++$i) {
        $row = $data[$i];
        $path = $row["path"];
        
        echo tabs(2)
            . '"' . $path . '"';
            
        if ($i + 1 < $count)
           echo ",";
           
        echo "\r\n";
    }
    
    echo "    ]\r\n";
    echo "}";
    


    // Log this query
    /*
    writeToDatabase(
       $credentials,
       '/my/queries/[]',
       urldecode($query)
    );
*/
    
    return true;
}

function word($alias) {


    $sql = <<<END
        inner join
            (
                select distinct
                    parents.parentValueId as valueId
                from
                    ValueParentChild as vpc
                inner join
                    ValueWord as vw
                on
                    vw.valueId = vpc.parentValueId
                inner join
                    Word as w
                on
                    w.wordId = vw.wordId
                inner join
                    ValueParentChild as parents
                on
                    parents.childValueId = vpc.childValueId
                where
                    w.lowerWord = ?
               # and
               #     parents.parentValueId != parents.childValueId

            ) as $alias
        on
            $alias.valueId = v.valueId

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
    return str_repeat("    ", $tabCount);
}
    

?>