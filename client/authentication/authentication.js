class Authentication
{
   constructor(authenticationServer = document.location.origin) {
      var creds = this.getCredentials();
      Object.assign(this, creds);
      this.authenticationServer =
         authenticationServer;
      this.url = this.authenticationServer;

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
         fetch(this.url + "/server/logon.php", parameters)
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
         /*
         .then(
            function(json) {
               _this.authenticated = 
                  json.authenticated;
               _this.sessionId =
                  json.sessionId;
               return _this;
            }
         );
         */
         
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
         document.cookie = "sessionId=;path=/;max-age=0;"
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
         fetch(this.url + "/server/authenticate.php", parameters)
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
   
   logoff()
   {
      var _this = this;
      
      var parameters = {
         method: "POST",
         credentials: "include"
      }
         
      var promise =
         fetch(this.url + "/server/logoff.php", parameters)
         .then(
            function(response) {
               response.json();
            }
         );
         
      this.authenticated = false;
      this.secret = null;
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

function authenticate() {

   var authentication =
      new Authentication(
         document.location.origin
      );
      
   if (authentication.authenticated)
      return true;
   var currentPage = document.location.href;
   var newPage = authentication.authenticationServer + "/logon.php";
   var url = newPage + "?redirect=" + encodeURIComponent(currentPage);
  
   document.location.href = url;
   
      
   return false;

}

