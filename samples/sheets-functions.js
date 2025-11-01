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

    return text;

}
function GETPATH(credentials, path) {

    const options = {
        method: "GET",
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

    return text;
}