class Authentication
{
    static _uploadProgressName = null;
    static _uploadMaxFilesize = null;
    
    constructor(authenticationServer = document.location.origin) {
        
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
    

    onUpdateJobs(jobs) {
    }
    
    redirect() {
        var currentPage = document.location.href;
        var newPage = this.url + "/client/authentication/logon.php";
        
        var currentURL = new URL(currentPage);
        var newURL = new URL(newPage);
        
        if (currentURL.origin != newURL.origin ||
            currentURL.pathname != newURL.pathname) {

            var url = newPage + "?redirect=" + encodeURIComponent(currentPage);
  
            document.location.href = url;
        }
    }
    
    fetch(url, parameters) {
        var _this = this;
        
        var credentials = this.credentials;
        var xAuthToken = null;
        if (credentials != null) {
            xAuthToken =
                encodeURIComponent(
                    JSON.stringify(credentials)
                );
        }

        var defaultParameters = {
            mode: "cors",
            method: "GET",
            credentials: "include",
            headers: {
                "X-Auth-Token": xAuthToken
            }
        }

        if (parameters)
            Object.assign(defaultParameters, parameters);
            
        var ok;
        var status;
        
        url = encodeSlashes(url);
        
        var fullURL = new URL(url, this.url);

        var promise =
            fetch(fullURL, defaultParameters)
            .then(
                (response) => {

                    _this.saveResponseCredentials(response);
                    ok = response.ok;
                    status = response.status;
                    return response.text();
                    
                }
            )
            .then(
                (text) => {

                    if (text == "undefined") {
                       return undefined;
                    }
    
                    var json = null;
                    
                    try {
                        json = JSON.parse(text);
                    }
                    catch (ex) {

                        // Error parsing
                        throw {
                            message: ex.toString(),
                            url: url,
                            text: text,
                            method: defaultParameters.method,
                            status: status,
                            where: "Authentication.fetch parse"
                        }
                    }

                    if (json &&
                        json["{Error}"] != undefined)
                    {
                        throw json["{Error}"];
                    }

                    return json;
                    
                    
                }
            );

        return promise;
        
        function encodeSlashes(url) {
            url = url.replace("%2F", "%252F");
            url = url.replace("%2f", "%252f");
            return url;
        }
    }
    
    postObject(url, object) {
    
        var parameters = {
            method: "POST",
            body: JSON.stringify(object)
        }
        
   
        var promise =
            this.fetch(
               url,
               parameters
            );
            
        return promise;
    }
    
    postFile(url, file) {

        var _this = this;

        var status = {
            label: "Uploading",
            done: false,
            path: url,
            cancel: false,
            progress: 0
        }

        var uploadProgressName;
        var jobPath;
        
        var promises = [
            this.getUploadMaxFilesize(),
            this.getUploadProgressName(),
            this.createJob(status)
        ];
        
    
        var promise =
            Promise.all(promises)
            .then(
                (values) => {
                    
                    var uploadMaxFilesize = values[0];
                    if (file.size > uploadMaxFilesize)
                    {
                        throw new Error(
                            "Uplpad Max file size is " +
                            uploadMaxFilesize
                        );
                    }
                    uploadProgressName =
                        values[1];

                    jobPath = values[2];
                    
                    var formData = new FormData();
                    
                    formData.append(
                        uploadProgressName,
                        jobPath
                    );
                    
                    formData.append(
                        "jobPath",
                        jobPath
                    );
                    
                    formData.append(
                        "uploadFile",
                         file
                    );
                    
                    
                    
                    var promise = _this.fetch(
                        url,
                        {
                            method: "POST",
                            body: formData
                        }
                    );
                    
                    _this.updateJobs([status]);

                    return promise;
                }
            )
            .then(
                (result) => {
                    var promise =
                    _this.updateJobs()
                    .then(
                        () => {
                            return result;
                        }
                    );
                    
                    return promise;
                }
            );
            
        return promise;
        
    }
    
    createJob(status) {
   
        var _this = this;

        return this.postObject(
            "/my/jobs/$",
            status
        )
        .then(
            (jobPath) => {

                var promise = _this.postObject(
                    jobPath + "/jobPath",
                    jobPath
                )
                .then (
                    () => {
                        return jobPath;
                    }
                );
                
                return promise;

            }
        );

    }
    
    
    updateJobs(jobs) {

        var _this = this;
        if (!jobs) {
            var promise = this.getJobs()
            .then(
                (jobs) => {
                    if (jobs === undefined)
                        jobs = [];
                    _this.updateJobs(jobs);
                }
            )
            .catch(
                (error) => {
                    //displayError(error, "Authentication.updateJobs");
                    this.setJobsTimeout();
                }
            );
            
            return promise;
        }

        var done = true;
        for (var i = jobs.length - 1;
             i >= 0;
             --i)
        {
            var job = jobs[i];
            if (job && !job.done) {
                done = false;
            }
        }
        
        if (this.onUpdateJobs) {
            this.onUpdateJobs(jobs);
        }

        if (!done)
            this.setJobsTimeout();
    
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
    
    
    logon(email, secret) {

        var _this = this;
        
        this.clearCredentials();
        
        if ( email == null || !email.length )
            throw new Error("Missing email");
        
        if ( secret == null || !secret.length )
            throw new Error("Missing secret");
        
        var parameters = {
            method: "POST",
            body: JSON.stringify(
                {
                    email: email,
                    secret: secret
                }
            )
        }

        var promise =
            this.fetch(
                this.url + "/server/authentication/logon.php", 
                parameters
            )
            .then(
                function(credentials) {
                    return credentials;
                }
            );
            
        return promise;
    }
    
    
    get authenticated() {
        var credentials = this.credentials;
        
        if (credentials != null) {
            var authenticated =
                credentials.authenticated;
            var now = new Date().getTime();

            authenticated =
                authenticated && (
                    credentials.expires > now
                );

            return authenticated;
        }
      
      return false;
        
    }

    refresh()
    {
        var promise =
            this.fetch(this.url + "/server/authentication/refresh.php")
            .then(
                function(authenticated) {
                    return authenticated;
                }
            );

        return promise;
    }
    
    
    getJobs() {

        var promise =
            this.fetch(this.url + "/server/json/updateUploadStatus.php");

        return promise;
    
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

        this.clearCredentials();
        
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
        this.clearCredentials();
        var promise =
            this.fetch(this.url + "/server/authentication/logoff.php")
            .then(
                function(json) {
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
    
    get credentialsKey() {
        var url = new URL(this.url);
        var key = "Credentials " + url.origin;
        return key;
    }
    
    get credentials() {
        
        var credentialsString =
            localStorage.getItem(
                this.credentialsKey
            );
        
        if (credentialsString) {
            return JSON.parse(
                credentialsString
            );
        }
        
        return null;
    }
    
    set credentials(credentials) {
        if (credentials == null)
            this.clearCredentials();
        else
            localStorage.setItem(
                this.credentialsKey,
                JSON.stringify(credentials)
            );
    }
    
    saveResponseCredentials(response) {
        
        var xAuthToken =
            response.headers.get("X-Auth-Token");
            
        if (xAuthToken)
        {
            this.credentials =
                JSON.parse(
                    decodeURIComponent(xAuthToken)
                );
        }
        else
            this.credentials = null;
        
    }
    
    clearCredentials() {
/*
        var pastDate = "Thu, 01 Jan 1970 00:00:00 UTC";
        var url = new URL(this.url);
        
        // Build the cookie string
        document.cookie =
            "credentials=; " +
            "expires=" + pastDate + "; " +
            "path=/; " +
            "domain=" + url.hostname;
*/
        localStorage.removeItem(
            this.credentialsKey
        );

        return;
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

    
    async createProcess(path) {
        var process = await this.fetch(path);
    
        var inputs = createInputs();
        var variables = createVariables();
        var processCases = createProcessCases();
        
        var code =
`var input = ${process.inputs};
var output;
while (1) {
    switch (next) {
${processCases}
    }
    input = output;
}
`;

        var code = tab(1, code);
        var body = variables + code;
        
        var f = new Function(
            ...inputs,
            body
        );
    
        return f;
        
        function createInputs() {
            var inputs = [];
            var inputKeys = Object.keys(process.inputs);
            for (var keyIndex in inputKeys) {
                var key = inputKeys[keyIndex];
                var defaultValue = process.inputs[key];
                var input = key;
                if (defaultValue != undefined)
                    input +=
                        " = " +
                        JSON.stringify(defaultValue);
                inputs.push(input);
            }
            
            return inputs;
        }
        
        function createVariables() {
    
            // create variables
            var processKeys =
                Object.keys(process.processes);
            
            var variables = "var next = " +
               JSON.stringify(processKeys[0]) +
               ";\n";
        
            var variableKeys =
                Object.keys(process.variables);
        
            for (var variableIndex in variableKeys) {
                var variableKey =
                    variableKeys[variableIndex];
                
                variables += "var " + variableKey;
            
                var defaultValue =
                    process.variables[variableKey];

                if (defaultValue != undefined)
                {
                    variables += " = " +
                        JSON.stringify(defaultValue);
                }
            
                variables += ";\n";
            
            }

            return tab(1, variables);
        }
        
        function createProcessCases() {
            var processCases = "";
            var processKeys =
                Object.keys(process.processes);
            for (var processIndex in processKeys) {
                var processKey = processKeys[processIndex];
                var proc = process.processes[processKey];
                var processCode =
                    createProcessCode(processKey);
                processCases +=
`case ${JSON.stringify(processKey)}:
${processCode}
    break;
`;
            }
            
            return tab(1, processCases);
        }
        
        function createProcessCode(processKey) {
            var code = "";
            var proc =
                process.processes[processKey];
            var processKeys =
                Object.keys(process.processes);
                
            if (proc["if"] != undefined)
            {
                proc = proc["if"];
                var trueNext = JSON.stringify(proc["true"]);

                var falseNext = JSON.stringify(proc["false"]);

                code =
`if (${proc.test})
    next = ${trueNext};
else
    next = ${falseNext};`;
            }
            else {
                code = proc.code + ";";
                var next =
                    proc.next;
                if (next != undefined) {
                    code += "\nnext = " +
                        JSON.stringify(next) +
                        ";";
                }
            
            }
            code = tab(1, code);
            return code;
        }
       
        function tab(tabs, string) {
            var lines = string.split("\n");
            var output = [];
            const tabSpaces = " ".repeat(tabs * 4);
            for (var index in lines) {
                var line = lines[index];
                if (line.trim() != "")
                    line = tabSpaces + line;
                output.push(line);
            }
            
            return output.join("\n");
        }

    }

}

class LogonError extends Error {
     constructor() {
          super("Please logon");
     }
}

