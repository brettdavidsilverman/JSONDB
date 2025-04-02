class Authentication
{
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
      var currentPage = document.location.href;
      var newPage = this.url + "/client/authentication/logon.php";
      var url = newPage + "?redirect=" + encodeURIComponent(currentPage);
  
      document.location.href = url;
   
      return false;

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

      var promise =
         this.fetch(this.url + "/server/authentication/logon.php", parameters)
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
         
         return authed && (
            !credentials.expires ||
            (credentials.expires > Date.now())
         );
      }
     
     return false;
      
   }
   
   set authenticated(value) {

      if (!value) {
         // document.cookie = "sessionId=;path=/;max-age=0;"
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
               return response.text();
            }
         )
         .then(
            function(text) {
               return _this.authenticated;
            }
         );

      return promise;
   }
   
   getUserEmailExists(email) {

      var parameters = {
         method: "POST",
         body: JSON.stringify(email)
      }
         
      var promise =
         this.fetch(this.url + "/server/authentication/userEmailExists.php", parameters)
         .then(
            function(response) {
               return response.json();
            }
         )
         .then(
            function(exists) {
               return exists;
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
         )
         .then(
            function(status) {
               return status;
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
         )
         .then(
            function(status) {
               return status;
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
         )
         .then(
            function(status) {
               return status;
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
         )
         .then(
            function(status) {
               return status;
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
         )
         .then(
            function(status) {
               return status;
            }
         );

      return promise;
   }
   
   
   
   
   logoff()
   {

      var promise =
         this.fetch(this.url + "/server/authentication/logoff.php")
         .then(
            function(response) {
               return response.json();
            }
         );
         
      this.authenticated = false;
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
      var cookie =
         "credentials=;" +
         "path=/;";
      
      if (response.ok) {
         var credentialsString =
         response.headers.get("x-auth-token");
         
         if (credentialsString == "logon") {
            throw "Please logon";
         }
         
         var credentials = null;
         if (credentialsString) {
            credentials = JSON.parse(
               decodeURIComponent(credentialsString)
            );
         }
         
         var expires = null;
         if (credentials && credentials.expires) {
    
            credentials.expires =
               this.mysqlDateToJavascript(
                  credentials.expires
               );
    
            credentialsString =
               encodeURIComponent(
                  JSON.stringify(credentials)
               );
               
            expires =
               credentials.expires.toUTCString();
         }
            
         if (credentials && credentials.authenticated) {
             
            cookie =
               "credentials=" +
               credentialsString + ";" +
               "path=/" + ";";
               
            if (expires)
               cookie += "expires=" + expires + ";"
         }
    
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
      
      if (credentials && credentials.expires) {
         credentials.expires =
            this.mysqlDateToJavascript(
               credentials.expires
            );
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
   
   fetch(url, parameters) {
      var _this = this;
      
      var defaultParameters = {
         mode: "cors",
         method: "GET",
         //credentials: "include",
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
   
   mysqlDateToJavascript(mysqlDate) {
      if (mysqlDate && 
          mysqlDate.constructor.name == "Date")
         return mysqlDate;
          
      if (mysqlDate.length == 19) {
         mysqlDate = mysqlDate.replace( /[-]/g, '/' );
         mysqlDate = mysqlDate.replace( /[+]/g, ' ' ) + " GMT";
         // parse the proper date string from the formatted string.
         mysqlDate = Date.parse( mysqlDate );
         
      }
      mysqlDate = new Date(mysqlDate);
      return mysqlDate;
         
   }


}


