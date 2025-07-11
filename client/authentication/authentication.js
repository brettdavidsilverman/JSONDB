class Authentication
{
    static _uploadProgressName = null;
    static _uploadMaxFilesize = null;

    constructor(authenticationServer = document.location.origin) {
        var creds = this.getCredentials();
        
        Object.assign(this, creds);
        this.authenticationServer =
            authenticationServer;
        this.url = this.authenticationServer;
    }
    
    authenticate() {
        if (this.authenticated)
            return true;
        this.onHandleLogon();

    }
    
    onHandleLogon() {
         this.redirect();
    }
    
    onUpdateStatus(status) {
    }
    
    onUpdateJobs(jobs) {
    }
    
    redirect() {
        var currentPage = document.location.href;
        var newPage = this.url + "/client/authentication/logon.php";
        if (currentPage != newPage) {
            var url = newPage + "?redirect=" + encodeURIComponent(currentPage);
  
            document.location.href = url;
        }
    }
    
    fetch(url, parameters) {
        var _this = this;

        var defaultParameters = {
            mode: "cors",
            method: "GET",
            headers: {
                "x-auth-token":
                    this.getCookie(
                        "credentials"
                    )
            }
        }
     
        if (parameters)
            Object.assign(defaultParameters, parameters);

        var ok;
        var status;
        
        var promise =
            fetch(url, defaultParameters)
            .then(
                (response) => {
                    _this.saveCredentials(response);
                    ok = response.ok;
                    status = response.status;
                    return response.text();
                }
            )
            .then(
                (string) => {

                    if (string == "undefined")
                       return undefined;
                       
                    var json = string;
                    var object;
                    
                    try {
                        json = JSON.parse(string);
                    }
                    catch (ex) {
                        // Error parsing
                        throw {
                            message: ex.toString(),
                            string: string,
                            url: url,
                            method: defaultParameters.method,
                            status: status,
                            where: "Authentication.fetch parse"
                        }
                    }
                    
                    return json;
                    
                    
                }
            );

        return promise;
    }
    
    postJSON(url, json) {
    

        var parameters = {
            method: "POST",
            body: json
        }
        var ok = false;
        var _this = this;
        var status = {
            label: "Saving...",
            percentage: 1,
            done: false
        }
        
        this.onUpdateStatus(status);
        
        var promise =
            this.fetch(
               url,
               parameters
            )
            .finally(
                () => {
                    status.done = true;
                    _this.onUpdateStatus(status);
                }
            );

            
        return promise;
    }
    
    postFile(url, file) {

        var _this = this;

        var status = {
            label: "Uploading...",
            percentage: 1,
            done: false
        }

        var uploadProgressName;
        
        var promises = [
            this.getUploadMaxFilesize(),
            this.getUploadProgressName(),
            this.setSessionStatus(status),
            this.setCancelLastUpload(false)
        ];
        
        var promise =
            Promise.all(promises)
            .then(
                (values) => {
                    
                    var maxFilesize = values[0];
                    if (file.size > maxFilesize)
                    {
                        throw new Error(
                            "Max file size is " +
                            maxFilesize
                        );
                    }
                    uploadProgressName =
                        values[1];
                        
                    var setSessionStatus =
                        values[2];
                        
                    if (!setSessionStatus)
                       throw new Error("Error setting session status");
                       
                    var setCancelUpload =
                        values[3];
                        
                    if (!setCancelUpload)
                       throw new Error("Error setting cancel upload");

                    var formData = new FormData();
                    formData.append(
                        uploadProgressName,
                        "postFile"
                    );
                    formData.append("file", file);
                    var promise = _this.fetch(
                        url,
                        {
                            method: "POST",
                            body: formData
                        }
                    );
                    return promise;
                }
            )
            .catch(
                (error) => {
                    var status = {
                        label: error,
                        percentage: 0,
                        done: true
                    }
                    _this.onUpdateStatus(
                        status
                    );
                }
            );
            
        return promise;
        
    }
    
    updateStatus(status) {
        /*
        var _this = this;
        if (!status) {
            this.getSessionStatus()
            .then(
                (status) => {
                    if (!status) {
                        status = {
                            label: "Ready...",
                            done: true
                        }
                    }
                    _this.updateStatus(status);
                }
            )
            .catch(
                (error) => {
                    displayError(error, "Authentication.updateStatus");
                }
            );
            
            return;
        }
        
        if (this.onUpdateStatus)
           this.onUpdateStatus(status);
        
        if (!status.done)
           this.setStatusTimeout();
    */

    }
    
    updateJobs(jobs) {
        /*
        var _this = this;
        if (!jobs) {
            this.getJobs()
            .then(
                (jobs) => {
                    if (!jobs) {
                        jobs = [];
                    }
                    _this.updateJobs(jobs);
                }
            )
            .catch(
                (error) => {
                    if (error.status == 404)
                       return;
                    displayError(error, "Authentication.updateJobs");
                }
            );
            
            return;
        }
        
        var done = true;
        for (var j in jobs) {
            if (!jobs[j].done) {
                done = false;
            }
        }
        
        if (this.onUpdateJobs)
           this.onUpdateJobs(jobs);
        
        if (!done)
            this.setJobsTimeout();
    */
    }
    
    setJobsTimeout() {
     
        var _this = this;
        
        if (this.jobsTimeoutId)
            window.clearTimeout(
                this.jobsTimeoutId
            );
  
        this.jobsTimeoutId = window.setTimeout(
            () => {
                _this.updateJobs();
            },
            1000 * 5
        );
    
    }
    
    setStatusTimeout() {
     
        var _this = this;
        
        if (this.timeoutId)
            window.clearTimeout(
                this.timeoutId
            );
  
        this.timeoutId = window.setTimeout(
            () => {
                _this.updateStatus();
            },
            1000 * 5
        );
        
    
    }

    
    logon(email, secret) {

        var _this = this;
        
        this.authenticated = false;
        
        if ( email == null || !email.length )
            throw new Error("Missing email");
        
        if ( secret == null || !secret.length )
            throw new Error("Missing secret");
        
        var parameters = {
            mode: "cors",
            method: "POST",
            body: JSON.stringify(
                     {
                         email: email,
                         secret: secret
                     }
                 )
        }

        var _this = this;
        var promise =
            this.logoff().then(
                () => {
                    return _this.fetch(_this.url + "/server/authentication/logon.php", parameters)
                }
            )
            .then(
                function(authenticated) {
                    _this.authenticated =
                        authenticated;
                        
                    return authenticated;
                }
            );
            
        return promise;
    }
    
    get authenticated() {
        var credentials = this.getCredentials();

        if (credentials != null) {
            var authed =
                credentials.authenticated;
            var now = new Date().getTime();

            authed = authed && (
                credentials.expires > now
            );
     
            return authed;
        }
      
      return false;
        
    }
    
    set authenticated(value) {

        if (!value) {
            document.cookie = "credentials=;path=/;max-age=0;"
        }
    }

    refresh()
    {
        var _this = this;

        var promise =
            this.fetch(this.url + "/server/authentication/refresh.php")
            .then(
                function(authenticated) {
                    _this.authenticated = authenticated;
                    return _this.authenticated;
                }
            );

        return promise;
    }
    
    getSessionStatus() {

        var promise =
            //this.fetch(this.url + "/my/jobs"
            this.fetch(
                this.url + "/server/getSessionStatus.php"
            );

        return promise;
    }
    
    setSessionStatus(
       status
    )
    {
        this.updateStatus(status);
        
        var parameters = {
            method: "POST",
            body: JSON.stringify(
                    status
                )
        }
        
        var promise =
            this.fetch(
                //this.url + "/my/status",
                this.url + "/server/setSessionStatus.php",
                parameters
            );
            
        return promise;
    }
    
    getJobs() {

        var promise =
            this.fetch(this.url + "/my/jobs");

        return promise;
    }
    
    getCancelLastUpload() {

            
        var promise =
            this.fetch(this.url + "/server/getCancelLastUpload.php");
            
        return promise;
    }
    
    setCancelLastUpload(
       cancelLastUpload
    )
    {
        var parameters = {
            method: "POST",
            body: JSON.stringify(
                cancelLastUpload
            )
        }

        var promise =
            this.fetch(
                this.url + "/server/setCancelLastUpload.php",
                parameters
            );
            
        return promise;
    }
    
    cancelLastUpload()
    {
        return this.setCancelLastUpload(true);
    }
    
    getUserEmailExists(email) {

        var parameters = {
            mode: "cors",
            method: "POST",
            body: JSON.stringify(email)
        }
            
        var promise =
            fetch(this.url + "/server/authentication/userEmailExists.php", parameters);

        return promise;
    }
    
    createUser(token, email, secret) {

        var parameters = {
            method: "POST",
            body: JSON.stringify(
                {
                    token: token,
                    email: email,
                    secret: secret
                }
            )
        }

        var promise =
            this.fetch(this.url + "/server/authentication/createUser.php", parameters);

        return promise;
    }
    
    validateUserEmail(email, newUserSecret) {

        var parameters = {
            method: "POST",
            body: JSON.stringify(
                {
                    email: email,
                    newUserSecret: newUserSecret
                }
            )
        }

        var promise =
            this.fetch(this.url + "/server/authentication/validateUserEmail.php", parameters);

        return promise;
    }
    
    lostSecret(token, email) {

        var parameters = {
            method: "POST",
            body: JSON.stringify(
                {
                    token: token,
                    email: email
                }
            )
        }

        var promise =
            this.fetch(this.url + "/server/authentication/lostSecret.php", parameters);

        return promise;
    }
    
    resetSecret(email, lostSecret, newSecret) {

        var parameters = {
            method: "POST",
            body: JSON.stringify(
                {
                    email: email,
                    lostSecret: lostSecret,
                    newSecret: newSecret
                }
            )
        }

        var promise =
            this.fetch(this.url + "/server/authentication/resetSecret.php", parameters);

        return promise;
    }
    
    changeSecret(email, oldSecret, newSecret) {

        this.authenticated = false;
        
        var parameters = {
            method: "POST",
            body: JSON.stringify(
                {
                    email: email,
                    oldSecret: oldSecret,
                    newSecret: newSecret
                }
            )
        }

        var promise =
            this.fetch(this.url + "/server/authentication/changeSecret.php", parameters);

        return promise;
    }
    
    
    
    
    logoff()
    {
        var _this = this;
        
        var promise =
            this.fetch(this.url + "/server/authentication/logoff.php")
            .then(
                function(json) {
                    _this.authenticated = false;
                    return json;
                }
            );
            
        
        return promise;
    }
    
    getCookie(name)
    {
        var cookies = document.cookie.split(";");
        for (var i in cookies)
        {
            var cookie = cookies[i];
            var parts = cookie.split("=");
            var _name = null;
            if (parts.length >= 1)
                _name = parts[0].trim();
            var value = null;
            if (parts.length >= 2)
                value = parts[1].trim();
            if (name == _name) {
                return value;
            }
                
        }
    
        return undefined;
        
    }
    
    setCredentials(credentials) {
         
        if (!credentials) {
             document.cookie =
                 "credentials=;" +
                 "path=/;";
            return;
            
        }
        
        var credentialsString =
            encodeURIComponent(
                JSON.stringify(
                    credentials
                )
            );
            
        var expires = "0";
        if (credentials.expires) {
     
            expires = 
                new Date(credentials.expires);
     
            expires =
                expires.toUTCString();
                    
        }

        var cookie;
        
        if (credentials.authenticated)
        {
                 
            cookie =
                "credentials=" +
                credentialsString + ";" +
                "path=/" + ";";
                    
            if (expires)
                cookie += "expires=" + expires + ";"
        }
        else
        {
            cookie =
                "credentials=;" +
                "path=/;";
        }
         
        document.cookie = cookie;

    }
    
    saveCredentials(response) {

         if (response.status == 401) {
             // clear cookie
             document.cookie =
                 "credentials=;" +
                 "path=/;";
             this.onHandleLogon();
             throw new LogonError();
         }
         
         var cookie;
         var credentialsString =
            response.headers.get("x-auth-token");
            
         var credentials = null;
         if (credentialsString) {
             credentials = JSON.parse(
                 decodeURIComponent(credentialsString)
             );
         }
          
         this.setCredentials(credentials);

    }
    
    
    getCredentials() {
        var credentialsString =
            this.getCookie(
                "credentials"
            );
        
        if (credentialsString)
            credentialsString =
                decodeURIComponent(
                    credentialsString
                );
                
        
            
        var credentials = null;
        
        if (credentialsString) {
            credentials = JSON.parse(credentialsString);
        }
        
        return credentials;
    }

    // Returns a base64 encode SHA-512 hash
    // of the file
    getFileHash(file) {
        const sha = new jsSHA("SHA-512", "ARRAYBUFFER");
        var fileReader = new FileReader();
        const promise = new Promise(
            function(resolve, reject) {
                fileReader.onloadend = function(event) {
                    const fileReader = event.target;
                    var result = fileReader.result;
                    var arrayBuffer = result;
                    var view = new Uint8Array(arrayBuffer);
                    sha.update(view);
                    var hash = sha.getHash("B64");
                    resolve(hash);
                    
                }
                fileReader.readAsArrayBuffer(file);
            }
        );

        return promise;

    }
    
    getUploadProgressName() {
    
        if (Authentication._uploadProgressName)
            return Promise.resolve(
                Authentication._uploadProgressName
            );
            
        var promise = this.fetch(
            this.url +
            "/server/json/getUploadProgressName.php"
        )
        .then(
            (text) => {
                Authentication._uploadProgressName = text;
                return text;
            }
        );
        
        return promise;
    }
    
    getUploadMaxFilesize() {
        if (Authentication._uploadMaxFilesize)
            return Promise.resolve(
                Authentication._uploadMaxFilesize
            );
            
        var promise = this.fetch(
            this.url +
            "/server/json/getUploadMaxFilesize.php"
        )
        .then(
            (text) => {
                var unit =
                    text.substr(-1, 1)
                    .toUpperCase();
                var value = Number(
                    text.substr(0, text.length -1)
                );
                
                var maxFilesize;
                
                switch (unit) {
                case "":
                    maxFilesize = value;
                case "K":
                    maxFilesize =
                        value *
                        1000;
                    break;
                case "M":
                    maxFilesize =
                        value  *
                         1000  *
                         1000;
                    break;
                case "G":
                    maxFilesize =
                        value *
                         1000 * 
                         1000 * 
                         1000;
                    break;
                case "T":
                    maxFilesize =
                        value *
                         1000 * 
                         1000 * 
                         1000 * 
                         1000;
                    break;
                case "P":
                    maxFilesize =
                        value *
                         1000 * 
                         1000 * 
                         1000 * 
                         1000 * 
                         1000;
                    break;
                }
                
                
                Authentication._uploadMaxFilesize =
                   maxFilesize;
            
                return maxFilesize;
            }
        );
        
        return promise;
    }

}

class LogonError extends Error {
     constructor() {
          super("Please logon");
     }
}


