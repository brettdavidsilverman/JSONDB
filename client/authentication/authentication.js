class Authentication
{
   static _uploadProgressName = null;
   static _maxFileSize = 8000000;
   
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

      var promise =
         fetch(url, defaultParameters)
         .then(
            (response) => {
               _this.saveCredentials(response);
               return response;
            }
         );

      return promise;
   }
   
   postJSON(url, json) {
      var parameters = {
         method: "POST",
         body: json
      }
    
      var promise =
         this.fetch(
            url,
            parameters
         ).
         then(
            function (response) {
               if (!response.ok)
                  throw new Error(
                     "Invalid status " +
                     response.status
                  );
               return response.json();
            }
         );

         
      return promise;
   }
   
   postFile(url, file, callback) {
      
      if (file.size >
          Authentication._maxFileSize)
      {
         return Promise.reject(
            "Max file size is " +
            Authentication._maxFileSize
         );
      }
         
      var _this = this;
      
      function getProgress()
      {
         _this.fetch(
            _this.url + "/testprogress.php"
         )
         .then(
            (response) => {
               return response.json();
            }
         )
         .then(
             (progress) => {
                 if (progress)
                    callback(progress);
             }
         )
         .catch(
            (error) => {
               window.clearInterval(intervalId);
               alert( error);
            }
         );
      }
      
      var intervalId;
      
      if (callback) {
         intervalId = window.setInterval(
           getProgress,
           5000
         );
         callback(
            {
               label: "Uploading...",
               percentage: 1,
               done: false,
               error: false
            }
         );
      }
      
      var promise =
         this.getUploadProgressName()
         .then(
            (name) => {
               var formData = new FormData();
               formData.append(name, "postFile");
               formData.append("file", file);
               return _this.fetch(
                  _this.url + "/testupload.php",
                  {
                     method: "POST",
                     body: formData
                  }
               );
            }
         )
         .then(
            (response) => {
               if (intervalId) {
                  window.clearInterval(
                     intervalId
                  );
               }
               
               
               return response.json()
            }
         )
         .then(
            (ok) => {

               if (callback) {
                   
                  var progress = {
                     label:
                        ok ?
                           "Finished uploading" :
                           "Error uploading",
                     percentage: 100,
                     done: true,
                     error: !ok
                  }
                  
                  callback(
                     progress
                  );
               }
               return ok;
               
            }
         );
         
      return promise;
      
   }
   
   
   logon(email, secret)
   {

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
               return _this.fetch(this.url + "/server/authentication/logon.php", parameters)
            }
         )
         .then(
            function(response) {
               return response.json();
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
            function(response) {
               return response.json();
            }
         )
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
         this.fetch(this.url + "/server/authentication/getSessionStatus.php")
         .then(
            function(response) {
               return response.json();
            }
         );

      return promise;
   }
   
   setSessionStatus(label, percentage, done) {

      var promise =
         this.postJSON(
            this.url + "/server/authentication/setSessionStatus.php",
            JSON.stringify(
               { label, percentage, done }
            )
         );

      return promise;
   }
   
   
   
   getUserEmailExists(email) {

      var parameters = {
         mode: "cors",
         method: "POST",
         body: JSON.stringify(email)
      }
         
      var promise =
         fetch(this.url + "/server/authentication/userEmailExists.php", parameters)
         .then(
            function(response) {
               return response.json();
            }
         );

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
         this.fetch(this.url + "/server/authentication/createUser.php", parameters)
         .then(
            function(response) {
               return response.json();
            }
         );

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
         this.fetch(this.url + "/server/authentication/validateUserEmail.php", parameters)
         .then(
            function(response) {
               return response.json();
            }
         );

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
         this.fetch(this.url + "/server/authentication/lostSecret.php", parameters)
         .then(
            function(response) {
               return response.json();
            }
         );

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
         this.fetch(this.url + "/server/authentication/resetSecret.php", parameters)
         .then(
            function(response) {
               return response.json();
            }
         );

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
         this.fetch(this.url + "/server/authentication/changeSecret.php", parameters)
         .then(
            function(response) {
               return response.json();
            }
         );

      return promise;
   }
   
   
   
   
   logoff()
   {
      var _this = this;
      
      var promise =
         this.fetch(this.url + "/server/authentication/logoff.php")
         .then(
            function(response) {
               _this.authenticated = false;
               return response.json();
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
        
       var expires = "0";
       if (credentials && credentials.expires) {
    
          expires = 
             new Date(credentials.expires);
    
          expires =
             expires.toUTCString();
               
       }

       if (credentials &&
           credentials.authenticated)
       {
             
          cookie =
             "credentials=" +
                credentialsString + ";" +
                "path=/" + ";";
               
          if (expires)
             cookie += "expires=" + expires + ";"

            
       }
       else if (credentials &&
                !credentials.authenticated)
       {
          cookie =
             "credentials=;" +
             "path=/;";
       }
       
       document.cookie = cookie;

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
         
      var _this = this;
      
      var promise = this.fetch(
         this.url +
         "/server/getUploadProgressName.php"
      )
      .then(
         (response) => {
             return response.text()
         }
      )
      .then(
         (text) => {
            Authentication._uploadProgressName = text;
            return text;
         }
      );
      
      return promise;
   }
   
   
   mysqlDateToJavascript(mysqlDate) {
       
      if (!mysqlDate)
         return null;
         
      if (typeof mysqlDate == "object")
         return mysqlDate;
    
      if (typeof mysqlDate == "string") {
         if (mysqlDate.length == 19) {
            mysqlDate = mysqlDate.replace( /[-]/g, '/' );
            mysqlDate = mysqlDate.replace( /[+]/g, ' ' ) + " GMT";
            // parse the proper date string from the formatted string.
            
         }
         mysqlDate = Date.parse( mysqlDate );
         mysqlDate = new Date(mysqlDate);
      }
      else if (typeof mysqlDate == "number")
         mysqlDate = new Date(mysqlDate);


      return mysqlDate;
         
   }


}

class LogonError extends Error {
    constructor() {
        super("Please logon");
    }
}