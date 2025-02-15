         <div>
            <label for="secretFile<?php echo "$thumbnailId" ?>">
               Secret
               <br />
               <img id="<?php echo $thumbnailId ?>" width="100" height="100"></img>
            </label>
            <input type="file" id="secretFile<?php echo "$thumbnailId" ?>" onchange="createThumbnail(this.files[0], document.getElementById('<?php echo $thumbnailId ?>'));" accept="image/*" style="display:none;" ></input>
            <canvas id="canvas" width="100" height="100" style="display:none;"></canvas>
         </div>