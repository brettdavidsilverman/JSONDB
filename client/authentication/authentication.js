class Authentication
{
   constructor(authenticationServer = document.location.origin) {
     // Object.assign(this, input);
      this.authenticated = false;
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
               return response.json();
            }
         )
         .then(
            function(json) {
               _this.authenticated = 
                  json.authenticated;
               _this.sessionId =
                  json.sessionId;
               return _this;
            }
         );

      return promise;
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
               return response.json()
            }
         )
         .then(
            function(json) {
               _this.authenticated =
                  json.authenticated;
               _this.sessionId =
                  json.sessionId;
               
               return _this;
            }
         );

      return promise;
   }
   
   logoff()
   {
      var _this = this;
      
      this.authenticated = false;

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
      document.cookie = "sessionId=;path=/;max-age=0;"
      return promise;
   }
   
}

function authenticate() {

   var authentication =
      new Authentication(
         document.location.origin
      );
   var promise =
      authentication.getStatus().
      then(
         function(auth) {
 
            if (!auth.authenticated) {
                
               var currentPage = document.location.href;
               var newPage = authentication.authenticationServer + "/client/logon/";
               var url = newPage + "?redirect=" + encodeURIComponent(currentPage);
               document.location.href = url;
            }
            return auth;
         }
      )
      .catch (
         function(error) {
            Error(error, authenticate);
          }
      );
      
   return promise;

}

