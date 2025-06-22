window.onerror =
function (message, source, lineno, colno, error)
{



    var stack = undefined;
    if (error && error.stack)
        stack = String(error.stack);
        
    var result = 
        {
            "error": message,
            "source": source,
            "lineno": lineno,
            "colno": colno,
            "stack": stack
        }

    if (alert.silent)
        console.log(result);
    else
        alert(result);
    
};

var hostname =
    window.location.hostname;
    
var port =
    window.location.port;



function require(src) {
    console.log("Must include '" + src + "'");
}

var module = {}

function writeln(pre, text)
{
    document.getElementById(pre)
        .appendChild(
            document.createTextNode(
                text + "\r\n"
            )
        );
}

Object.prototype.toString = function() {
    
    return JSON.stringify(this, null, "    ");
}

function displayError(error, f)
{
     var where;
     if (typeof f == "string")
         where = f
     else if (typeof f == "function")
         where = f.name;
     else if (f)
         where = f;
     else
         where = "Unknown function";
         
     window.onerror(error, where, undefined, undefined, error);
     
}

class CheckError extends Error
{    
    constructor(label)
    {
        super("Check failed for " + label);
        this.label = label;
    }
    
}

function CHECK(label, bool)
{
    if (bool == false)
    {
        throw new CheckError(label);
    }
}
