<?php

//require_once "../functions.php";


function userEmailExists($connection, $email)
{
    $statement = $connection->prepare(
      "SELECT userEmailExists(?)"
    );
    
    $statement->bind_param('s', $email);
    
    $statement->execute();
    
    $statement->bind_result($exists);
    
    if ($statement->fetch()) {
        $exists = (bool)$exists;
    }
    else {
        $exists = NULL;
    }
    
    $statement->close();
    
    return $exists;
}

function createUser($connection, $token, $email, $secret)
{
    
    if (!validateReCaptchaToken($token))
        return NULL;
        
    $statement = $connection->prepare(
      "CALL createUser(?, ?);"
    );
    
    $statement->bind_param('ss', $email, $secret);
    
    $statement->execute();
    
    $userId = NULL;
    $newUserSecret = NULL;
    
    $statement->bind_result($userId, $newUserSecret);
    
    if (!$statement->fetch()) {
        return NULL;
    }
    
    $statement->close();
    
    return $newUserSecret;
}


function lostSecret($connection, $token, $email)
{
    
    if (!validateReCaptchaToken($token))
        return NULL;
        
    $statement = $connection->prepare(
      "CALL lostSecret(?);"
    );
    
    $statement->bind_param('s', $email);
    
    $statement->execute();
    
    $lostSecret = NULL;
    
    $statement->bind_result($lostSecret);
    
    if (!$statement->fetch()) {
        return NULL;
    }
    
    $statement->close();
    
    return $lostSecret;
}

function resetSecret($connection, $email, $lostSecret, $newSecret)
{
    $statement = $connection->prepare(
      "CALL resetSecret(?,?,?);"
    );
    
    $statement->bind_param('sss', $email, $lostSecret, $newSecret);
    
    $statement->execute();
    
    $success = NULL;
    
    $statement->bind_result($success);
    
    if (!$statement->fetch()) {
        return null;
    }
    
    $statement->close();
  
    return (bool)$success;
}

function validateUserEmail($connection, $email, $newUserSecret)
{
    $statement = $connection->prepare(
      "CALL validateUserEmail(?, ?);"
    );
    
    $statement->bind_param('ss', $email, $newUserSecret);
    
    $statement->execute();
    
    $userValidated = NULL;
    
    $statement->bind_result($userValidated);
    
    if (!$statement->fetch()) {
        return false;
    }
    
    $statement->close();
    
    return $userValidated;
}

function logon($connection, $email, $secret)
{
    
    $ipAddress = getClientIPAddress();
    
    $statement = $connection->prepare(
      "CALL logon(?, ?, ?);"
    );
    

    $statement->bind_param(
        'sss',
        $email,
        $secret,
        $ipAddress
    );
    
    $statement->execute();
    
    $statement->bind_result(
        $userId,
        $sessionKey,
        $expires
    );
    
    if (!$statement->fetch())
        $sessionKey = NULL;
        
    $statement->close();
    
    if (!is_null($sessionKey))
    {
        $credentials = array(
            "userId" => $userId, 
            "expires" => $expires,
            "authenticated" => true,
            "sessionKey" => $sessionKey,
            "email" => $email
        );
        

    }
    else
    {
        $credentials = null;
    }
    
    
    return $credentials;
}

function logoff($connection)
{
    $statement = $connection->prepare(
      "CALL logoff(?);"
    );
    
    $credentials = getCredentialsCookie();
    
    if (!is_null($credentials) &&
         $credentials["sessionKey"])
    {
        $statement->bind_param(
            's',
            $credentials["sessionKey"]
        );
    
        $statement->execute();

    }
    
    $statement->close();
 
}

function changeSecret($connection, $email, $oldSecret, $newSecret)
{
    $statement = $connection->prepare(
      "CALL changeSecret(?, ?, ?);"
    );
    
    $statement->bind_param('sss', $email, $oldSecret, $newSecret );
    
    $statement->execute();
    
    $statement->bind_result(
        $result
    );
    
    if (!$statement->fetch())
        $result = false;
        
    $statement->close();
    
    
    
    return (bool)$result;
}

function setCredentialsCookie($credentials)
{
    
    $expires = null;
     
    if (!is_null($credentials)) {

        $expires = $credentials["expires"];
        // Convert milliseconds
        // to seconds
        $expires = $expires / 1000;
    }

    if (is_null($expires)) {
        // Set expires to 1/2 hour ago
        $expires = time() - 30 * 60;
    }
    
    $credentialsString = null;
    
    if (!is_null($credentials))
    {
        $credentialsString =
            json_encode($credentials);
    }
    
    if (!is_null($credentialsString))
        header("X-Auth-Token: " . urlencode($credentialsString));

    setcookie(
        "credentials",
        $credentialsString,
        [
            "expires" => $expires,
            "path" => "/",
            "secure" => true, // Recommended for production
            "httponly" => false, // Recommended for security
            "samesite" => "None" // Can be 'Strict', 'Lax', or 'None'
        ]
    );
    
}


function getCredentialsCookie()
{

    $credentialsString =
        getHeader("X-Auth-Token");
    
    if (!is_null($credentialsString))
        $credentialsString =
            urldecode($credentialsString);
            

    if (is_null($credentialsString) &&
        array_key_exists("credentials", $_COOKIE))
    {
        $credentialsString =
            $_COOKIE["credentials"];
    }


    if (!is_null($credentialsString))
    {
        $credentials = json_decode(
            $credentialsString,
            true
        );
        
        return $credentials;
    }
    

    return null;
}


function getCredentials($connection, $ignoreExpires = false)
{
     
    $credentials = getCredentialsCookie();

    if (is_null($credentials) ||
        !is_array($credentials) ||
        !array_key_exists("sessionKey", $credentials)
        )
    {
        return null;
    }
    
    $ipAddress = getClientIPAddress();
    
    $statement = $connection->prepare(
      'CALL authenticate(?, ?, ?);'
    );
    
    $statement->bind_param(
        'ssi',
        $credentials["sessionKey"],
        $ipAddress,
        $ignoreExpires
    );
    
    $statement->execute();

    $statement->bind_result(
        $sessionKey,
        $userId,
        $email,
        $expires
    );
    

    if ($statement->fetch()) {
        $credentials = array(
            "userId" => $userId, 
            "expires" => $expires,
            "authenticated" => true,
            "sessionKey" => $sessionKey,
            "email" => $email
        );
    }
    else {
        $credentials = null;
    }
        
    $statement->close();
    
  
    return $credentials;
}


function authenticate($ignoreExpires = false)
{
     
    $connection = getConnection();
    
    $credentials = getCredentials(
        $connection,
        $ignoreExpires
    );
    

    $connection->close();
    
    $isFetchClient =
         !is_null(
             getHeader("X-Auth-Token")
         );
         
    if (is_null($credentials) ||
        $credentials["authenticated"] !== true) {
         
        if ($isFetchClient) {
            http_response_code(401);
            header("content-type: application/json");
            echo json_encode("Invalid credentials");
        }
        else {
            $url = '/client/authentication/logon.php';
            $redirect = $_SERVER['REQUEST_URI'];
            $url = $url . '?redirect=' . urlencode($redirect);
            redirect($url);
        }
        
        exit();

    }
    
    
    return $credentials;

}


function refresh() {

    $connection = getConnection();
    $credentials = getCredentials($connection);
    $connection->close();

    return $credentials;

}




?>