function GETCREDENTIALS(email, secret) {

    const data = {
        email: email,
        secret: secret
    };

    const options = {
        method: 'post',
        contentType: 'application/json',
        payload: JSON.stringify(data),
    };

    const response = 
        UrlFetchApp.fetch(
            'https://bee.fish/server/authentication/logon.php',
            options
        );

    const text = response.getContentText();

    const credentials =
        JSON.parse(text);
        
    if (!credentials.authenticated)
        throw new Error("Invalid email or secret");
        
    return text;

}

function GETPATH(credentials, path) {

    const options = {
        method: "GET",
        muteHttpExceptions: true,
        headers: {
            "x-auth-token" : encodeURIComponent(credentials)
        }
    };

    if (path.startsWith("/"))
       path = path.substr(1);

    const response = 
        UrlFetchApp.fetch(
            'https://bee.fish/' + path,
            options
        );

    const text = response.getContentText();
    const code = response.getResponseCode();
    
    if (code != 200)
       throw new Error(text);

    const json = JSON.parse(text);
    
    if (typeof json == "object" &&
        !Array.isArray(json))
        return text;
    
    return json;
}