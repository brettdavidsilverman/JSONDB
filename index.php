<?php
   require_once "server/authentication/functions.php";
   
   authenticate();
?>
<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <title id="title">bee.fish</title>
      <base href="/">
      <script src="/client/head.js?v=1"></script>
      <script src="/client/stream/stream.js"></script>
      <script src="/client/power-encoding/power-encoding.js"></script>
      <script src="/client/id/id.js"></script>
      <script src="/client/evaluate.js?v=1"></script>      <script src="/client/authentication/authentication.js?v=2"></script>
      <script src="/client/punycode.js"></script>
      <link rel="stylesheet" type="text/css" href="style.css"/>
      <script>

      </script>
   </head>
   <body>
      <h1 id="h1">bee.fish</h1>
      
      <div>
         <form onsubmit="return false;">
            <div style="text-align:left;">
               <label for="pathInput">Path</label>
            </div>
            <input type="text" id="pathInput"/>
            <button id="fetchButton" onclick="loadJSON()">Fetch</button>
            <br/>
         </form>
         <br/>
         <form onsubmit="return false;">
            <div style="text-align:left;">
               <label for="jsonEditor">
                  JSON Editor
               </label>
               <br/>
               <label for="functionCheckbox">
                  <i>f()</i>
               </label>
               <input type="checkbox"
                      id="functionCheckbox"
                      onclick="switchFunctions(this.checked)" 
               />            </div>
            <textarea id="jsonEditor"></textarea>
            <button id="saveButton">Save</button>
         </form>
         
      </div>
      <h2>
         <a id="goLink" href="/go.php">App Link</a>
      </h2>
      <h2>
         <a id="dataLink" href="/">Data Link</a>
      </h2>
      <br />
      <br />
     
      <a href="client/authentication/logon.php" id="logon">Logon/Logoff</a>
      <br />
      <a href="client/authentication/changeSecret.php">Change logon secret</a>
      <br />
      <a href="/client">Javascript client library</a>
      <br />
      <a href="https://github.com/brettdavidsilverman/JSONDB">JSONDB on Git Hub</a>
      
      <script>
var authentication = new Authentication();

const defaultURL = 
   "/my";
   var logon = document.getElementById("logon");
logon.href += "?redirect=" + encodeURIComponent(window.location.href);

var pathInput = document.getElementById("pathInput");
var result = document.getElementById("result");
var jsonEditor = document.getElementById("jsonEditor");var html = document.getElementById("html");var fetchButton = document.getElementById("fetchButton");var saveButton = document.getElementById("saveButton");var functionCheckbox = document.getElementById("functionCheckbox");var goLink = document.getElementById("goLink");
var dataLink = document.getElementById("dataLink");
var header = document.getElementById("h1");
var title = document.getElementById("title");

var origin =
   punycode.toUnicode(
      window.location.hostname
   );

header.innerText = origin;
title.innerText = origin;

fetchButton.disabled = true;
saveButton.disabled = true;

//authentication.authenticate();
function loadJSON() {
    
   var url = getURL();
   pathInput.value = url;
   
   fetchButton.disabled = true;
   
   localStorage.setItem("path", url);

   authentication.authenticate();
   
   var promise =
   fetch(url).
      then(
         function (response) {
            status = response.status;
            return response.text();
         }
      ).
      then(
         function (json) {
            if (status != "200") {
               throw json;
            }
            return json;
         }
      ).
      then(
         function(json) {
            jsonEditor.value = json;
            
            fetchButton.disabled = false;
            saveButton.disabled = false;
        /*
            switchFunctions(
               functionCheckbox.checked
            );
            */
            return json;
         }
      )
      .catch(
         function (error) {
            fetchButton.disabled = false;
            DisplayError(error, loadJSON);
         }
      );
   
   return promise;
      
}


if (!pathInput.value)
   pathInput.value = defaultURL;
   
pathInput.onfocus = 
   function() {
      fetchButton.disabled = false;
      saveButton.disabled = false;
   };
   
   
pathInput.onblur =
   function() {
      fetchButton.disabled = false;
      saveButton.disabled = false;
      setLinks();
   }

saveButton.onclick =
   function() {
    
      var json;
   
      try {
         localStorage.setItem("json", jsonEditor.value);
         json = formatJSON(jsonEditor.value);
      }
      catch (error) {
         DisplayError(error, "saveButton.onclick");
         return;
      }
      
      saveButton.disabled = true;
      
      authentication.authenticate();
      var url = getURL();
      pathInput.value = url;
      
      postJSON(
         url,
         json
      ).
      then(
         function (json) {
            alert(json);
         }
      ).
      catch(
         function (error)
         {
            DisplayError(error, "saveButton.onclick");
         }
      ).
      finally(
        function() {
           saveButton.disabled = false;
        }
      );
   }

fetchButton.onclick =
   function() {

      loadJSON();

   }
   

function switchFunctions(showFunctions)
{

   var json = getJSON();
   
   if (showFunctions) {
      json = displayFunctions(json);
   }
   else {
      json = hideFunctions(json);
      json = JSON.stringify(json, null, "   ");
   }
   jsonEditor.value = json;
}
function getURL() {
   var url = pathInput.value;
   
   if (url == "")
      return "/my";
      
   if (url.startsWith("/"))
      url = url.substr(1);

   var first = url.split("/")[0];
   
   if (first != "my" && !isInteger(first))
   {
      if (url)
         url = "/my/" + url;
      else
         url = "/my";
   }
   
   if (!url.startsWith("/"))
      url = "/" + url;
      
   if (url.endsWith("/"))
      url = url.substr(0, url.length - 1);
      
   pathInput.value = url;
   
   return url;
}

function isInteger(value) {
   var n = parseFloat(value);
   return !isNaN(n) && Number.isInteger(n);
}

function getJSON()
{
   var json = jsonEditor.value;
   
   if (json == "")
      return undefined;
      
   var f = new Function(
      "return (" + json + ")"
   );
   json = f();
   return json;
}
function setLinks() {
   var url = getURL();
   goLink.href = "/go.php?" + encodeURIComponent(url);
   dataLink.href = url;
}
if (localStorage.getItem("path")) {

   pathInput.value =
      localStorage.getItem("path");
      
   fetchButton.disabled = false;
   saveButton.disabled = false;
}

if (localStorage.getItem("json")) {

   jsonEditor.value =
      localStorage.getItem("json");
}setLinks();

      </script>

   </body>

</html>