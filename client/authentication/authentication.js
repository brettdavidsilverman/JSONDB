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
      var newPage = "/client/authentication/logon.php";
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
         method: "POST",
         credentials: "include",
         body: JSON.stringify(
                {
                   email: email,
                   secret: secret
                }
             )
      }

      var promise =  
         fetch(this.url + "/server/authentication/logon.php", parameters)
         .then(
            function(response) {
               if (response.ok) {
                  var creds =
                     _this.getCredentials();
                  Object.assign(_this, creds);
               }
               else {
                  _this.authenticated = false;
               }
               
               return _this.authenticated;
            }
         );
         
      return promise;
   }
   
   get authenticated() {
      var credentials = this.getCredentials();

      if (credentials != null) {
         var expiryDate = new Date(credentials.expiryDate);
         var authed =
            (expiryDate > new Date()) &&
            (credentials.authenticated);
         return authed;
      }
     
     return false;
      
   }
   
   set authenticated(value) {

      if (!value) {
         // document.cookie = "sessionId=;path=/;max-age=0;"
         document.cookie = "path=/;max-age=0;"
      }
   }
   
   getStatus()
   {
      var _this = this;
      
      this.authenticated = false;
      
      var parameters = {
         method: "GET",
         credentials: "include"
      }
         
      var _this = this;

      var promise =
         fetch(this.url + "/server/authentication/authenticate.php", parameters)
         .then(
            function(response) {
               if (response.ok) {
                  var creds =
                     _this.getCredentials();
                  Object.assign(_this, creds);
               }
               else
                  _this.authenticated = false;
                  
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
         fetch(this.url + "/server/authentication/userEmailExists.php", parameters)
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
         fetch(this.url + "/server/authentication/createUser.php", parameters)
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
         fetch(this.url + "/server/authentication/validateUserEmail.php", parameters)
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
         fetch(this.url + "/server/authentication/lostSecret.php", parameters)
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
         fetch(this.url + "/server/authentication/resetSecret.php", parameters)
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
         fetch(this.url + "/server/authentication/changeSecret.php", parameters)
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
      
      var parameters = {
         method: "POST",
         credentials: "include"
      }
         
      var promise =
         fetch(this.url + "/server/authentication/logoff.php", parameters)
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
   
   getCredentials() {
      var cookie = this.getCookie("credentials");
      if (cookie) {
         cookie = decodeURIComponent(cookie);
         return JSON.parse(cookie);
      }
      return null;
   }


}




