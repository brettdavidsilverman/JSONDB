function createThumbnail(file, thumbnail, onload)
{

   // Create a thumbail copy from
   // secret file and draw it
   // on the canvas.
   thumbnail.src = "";
   
   var _this = this;
     
   prepareCanvas(canvas);
      
   var image;
      
      
   // Read the secretFile
   var fileReader = new FileReader();
      
   // onload fires after reading is complete
   fileReader.onload = createImage;
      
   // begin reading
   fileReader.readAsDataURL(file);
      
    
   function createImage()
   {
      image = new Image();
         
      image.width = 100;
            
      image.height = 100;
            
      image.onload = imageLoaded;
      
      image.src = fileReader.result;
         
   }
      
   function imageLoaded()
   {
   
      var context = canvas.getContext("2d");
      
      // draw the image
      context.drawImage(
         image, 0, 0, canvas.width, canvas.height
      );         

      // get the image
      var jpeg =
         canvas.toDataURL("image/jpeg", 0.5);
     
      // set the existingThumbnail
      thumbnail.src = jpeg;

      createSecret(file, thumbnail, onload);
      
   }
      
   function prepareCanvas(canvas)
   {
      canvas.width = 100;    
      canvas.height = 100;
      
      var context = canvas.getContext("2d");
         
      // draw the image
      context.clearRect(
         0, 0, canvas.width, canvas.height
      );         
   }
      

}

function createSecret(file, thumbnail, onload)
{

   thumbnail.classList.remove("pressed");
   
   thumbnail.style.filter = "grayscale(100%)";
   
   getFileHash(file)
   .then(
      function(secret) {
         thumbnail.style.filter = "none";
         thumbnail.secret = secret;
         if (onload)
            onload(secret)
      }
   );
   
}

// Returns a base64 encode SHA-512 hash
// of the file
function getFileHash(file) {
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

function getRedirect() {
   const params = new URL(document.location.href).searchParams;
   
   var redirect;
   
   if (params.has("redirect"))
      redirect = params.get("redirect");
   else
      redirect = "/";
      
   return redirect;
               
}

