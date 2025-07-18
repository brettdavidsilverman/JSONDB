<?php
    require_once "server/functions.php";
    
    $credentials = authenticate();
    
    http_response_code(200);
    
    header("content-type: text/html");
    
    setCredentialsCookie($credentials);
    
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title id="title"><?php echo getConfig()["Domain"] ?></title>
        <script src="/client/head.js?v=2"></script>
        <script src="/client/stream/stream.js"></script>
        <script src="/client/power-encoding/power-encoding.js"></script>
        <script src="/client/id/id.js"></script>
        <script src="/client/evaluate.js?v=1"></script>        <script src="/client/authentication/authentication.js?v=28"></script>
        <script src="/client/punycode.js"></script>
        <link rel="stylesheet" type="text/css" href="style.css"/>
        <style>
form > div {
    text-align: left;
}

#cancelLastUpload {
    
}

        </style>
    </head>
    <body>
        <h1 id="h1"><?php echo getConfig()["Domain"] ?></h1>
        
        <div id="expires"></div>
        
        <div>
            <form onsubmit="return false;">
                <div>
                    <label for="pathInput">Path</label>
                </div>
                <input type="text" id="pathInput"/>
                <button id="fetchButton" onclick="loadJSON()">Fetch</button>
                <br/>
            </form>
            <br/>
            <form onsubmit="return false;">
                <div>
                    <label for="fileInput">File</label>
                </div>
                <input type="file" id="fileInput" onchange="loadFile()"/>
                <br/>
            </form>
            <br/>
            <form onsubmit="return false;">
                <div>
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
                    />
                    <button id="clearButton">Clear</button>                </div>
                <textarea id="jsonEditor"></textarea>
                <button id="saveButton">Save</button>
                <br/>
                <br/>
                
                <div id="jobs">
                </div>
                
                <div id="job" style="visibility:hidden;">
                    <label for="progress"><span class="progressLabel"></span></label>
                    <progress class="progress" value="0" max="100"></progress>
                    <span class="cancelUpload">❌</span>
                </div>

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
        <a href="/archive">Archive suite</a>
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
var jsonEditor = document.getElementById("jsonEditor");var html = document.getElementById("html");var fetchButton = document.getElementById("fetchButton");
var fileInput = document.getElementById("fileInput");var saveButton = document.getElementById("saveButton");var clearButton = document.getElementById("clearButton");var functionCheckbox = document.getElementById("functionCheckbox");var goLink = document.getElementById("goLink");
var dataLink = document.getElementById("dataLink");
var header = document.getElementById("h1");
var title = document.getElementById("title");
var progress = document.getElementById("progress");
var progressLabel = document.getElementById("progressLabel");
var cancelUpload = document.getElementById("cancelUpload");
var jobDiv = document.getElementById("job");
var jobsDiv = document.getElementById("jobs");

var origin =
    punycode.toUnicode(
        window.location.hostname
    );

header.innerText = origin;
title.innerText = origin;

fetchButton.disabled = true;

authentication.onHandleLogon =
    function() {
        authentication.redirect();
        
        return false;
    }
    
var uploadJob;

authentication.onUpdateStatus =
   (status) => {
       displayExpires();
       uploadJob = status;
       if (uploadJob.done)
           saveButton.disabled = false;
       authentication.updateJobs()
    }
        
authentication.onUpdateJobs =
    (jobs) => {
        displayExpires();
        jobsDiv.innerHTML = "";
        
        if (!Array.isArray(jobs))
            return;

        if (uploadJob && uploadJob.done)
           uploadJob = null;
        
        jobs.unshift(uploadJob);
        
        
        var job;
        for (var j in jobs) {
            job = jobs[j];
            if (job)
                setJob(job, j - 1);
        }
      
        
   }
   
function setJob(job, index) {
    
    var newJobDiv = jobDiv.cloneNode(true);
    
    newJobDiv.style.visibility = "visible";
    
    var progressLabel =
       newJobDiv.querySelector(".progressLabel");
    var progress =
       newJobDiv.querySelector(".progress");
    var cancelUpload =
       newJobDiv.querySelector(".cancelUpload");
       
    progressLabel.innerText = job.label;
    
    
    if (job.percentage >= 0) {
        progress.style.visibility =
            "visible";
        progress.value = job.percentage;
    }
    else {
        progress.style.visibility =
            "hidden";
    }
                
    if (job.done) {
        cancelUpload.style.visibility =
            "hidden";
    }
    else {
        cancelUpload.style.visibility =
            "visible";
    }
    
    cancelUpload.onclick =
        function() {
            if (confirm("Press OK to stop upload ❌")) {
               if (index === -1)
                   authentication.cancelLastUpload();
               else
                   authentication.postJSON(
                       "/my/jobs/" + index + "/cancelled",
                       true
                  );
            }
        }

    
    if (index >= 0) {
        newJobDiv.onclick =
            function()
            {
                pathInput.value = "/my/jobs/" + index;
                fetchButton.onclick();
            }
    }
        
    jobsDiv.appendChild(newJobDiv);
}
    
//authentication.authenticate();function loadFile() {
     fileInput.disabled = true;
     var file = fileInput.files[0];
     fileInput.value = null;
     var fileReader = new FileReader();
     
     fileReader.onload =
         () => {
              jsonEditor.value =
                    fileReader.result;
              fileInput.disabled = false;
         }
         
     if (file)
          fileReader.readAsText(file);
     else
          fileInput.disabled = false;
     
}

fetchButton.onclick = function() {
     
    var url = getURL();
    pathInput.value = url;
    
    fetchButton.disabled = true;
    
    authentication.authenticate();
    
    localStorage.setItem("path", url);

    var promise =
    authentication.fetch(url)
    .then(
        function(json) {
            
            jsonEditor.value =
               JSON.stringify(json, null, "  ");
               
            fetchButton.disabled = false;
            
            if (typeof json == "string") {
                var string = json;
                if (string.startsWith("{") &&
                    string.endsWith("}"))
                {
                    string = eval(string);
                }
            }
            
            /*
            var object = 
                eval("(" + string + ")");
               
            if (typeof object == "function")
                functionCheckbox.checked = true;
            else
                functionCheckbox.checked = false;
            */
          /*
            switchFunctions(
                functionCheckbox.checked
            );
                */
            return json;
        }
    )
    .catch(
        (error) => {
            fetchButton.disabled = false;
            alert(error);
            /*
            if (error.status = 404)
               alert("🛑 Path " + error.path + " not found.");
            else
               displayError(error, "fetchButton.onclick");
               */
        }
        
    )
    .finally(
        () => {
                 
            displayExpires();
                
        }
    );
    
    return promise;
        
}


saveButton.onclick =
    function() {
        
        var url = getURL();
        
        saveButton.disabled = true;        
        
        authentication.authenticate();
        var json;
        try {
            json = jsonEditor.value;
            var object = JSON.parse(json);
            json = JSON.stringify(object);
        }
        catch(error) {
            displayError(error, "saveButton.onclick");
            
            return;
        }
        finally {
            saveButton.disabled = false;
        }
        
        alert("Saving...");
                var promise;
        
        if (json.length > 1000) {
            var file = new Blob(
                [json],
                {
                    type: "application/json; charset=utf-8"
                }
            );

            promise =
                authentication.postFile(
                    url,
                    file
                );
        }
        else {
            promise =
                authentication.postJSON(
                    url,
                    json
                );
                
        }
        
        promise
            .then(
                (result) => {
                   if (result == undefined)
                      alert("🛑 Invalid path");
                   else 
                      alert(result);
                }
            )
            .catch(
                (error) => {
                    displayError(error, "saveButton.onclick");
                    
                }
            )
            .finally(
                () => {
                    saveButton.disabled = false;
                }
            );
        
        
        return promise;
    }
    
clearButton.onclick =
    function() {
        jsonEditor.value = "";
    }


if (!pathInput.value)
    pathInput.value = defaultURL;
    
pathInput.onfocus = 
    function() {
        fetchButton.disabled = false;
    };
    
    
pathInput.onblur =
    function() {
        fetchButton.disabled = false;
        setLinks();
    }

function switchFunctions(showFunctions)
{

    var json = getJSON();
    
    if (showFunctions) {
        json = displayFunctions(json);
    }
    else {
        json = hideFunctions(json);
        json = JSON.stringify(json, null, "    ");
    }
    jsonEditor.value = json;
}
function getURL(publish = false) {
    var url = pathInput.value;
    
    if (url == "")
        return "/my";
        
    var first;
    if (url.includes("?")) {
        first = url.split("?")[0];
    }
    else {
        first = url.split("/")[1];
    }
        
        
    pathInput.value = url;
    
    if (publish && authentication.userId && !isInteger(first)) {
        url =
            "/" + 
            authentication.userId.toString() +
            "/" +
            url.substr(4);
                
    }
    
    // Double encode slashes to allow
    // apache to pass them through
    // The server similarly decodes them
    
    // upper case
    url = url.replaceAll("%2F", "%252F");
    
    // lower case
    url = url.replaceAll("%2f", "%252f");
    
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
    var url = getURL(true);
    goLink.href = "/go.php?" + encodeURIComponent(url);
    dataLink.href = url;
}
if (localStorage.getItem("path")) {

    pathInput.value =
        localStorage.getItem("path");
        
    fetchButton.disabled = false;
}
setLinks();

function displayExpires() {
    var div = document.getElementById("expires");
    
    var credentials =
        authentication.getCredentials();
        
    if (credentials) {
        var expires = credentials.expires;
        div.innerText = new Date(expires);
    }
    else
        div.innerText = "No credentials";
    
 
}



//authentication.updateStatus();
//authentication.updateJobs();

        </script>

    </body>

</html>