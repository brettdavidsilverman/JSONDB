class Match {
    #inputs;
    #success = undefined;
    #value = null;
    
    constructor(...inputs) {
        this.#inputs = inputs;
    }
   
    match(character) {
    
    }
   
    read(string, end = true) {
     
        var matched;
        var i;
        for (i = 0;
             i < string.length;
            )
        {
            var character = string[i];
         
            var matched =
                this.match(character);
         
            if (matched) {
                document.write(
                   "{" + 
                   character + 
                   "}"
                );

            }
            
            if (this.success !=
                undefined)
                break;
            
            if (matched)
                ++i;
        }
      
        if (end)
            this.readEnd();
         
        return i;
      
    }
   
    readEnd() {
    }
   
    get success() {
        return this.#success;
    }
   
    set success(value) {
        if (value != this.#success)
        {
            this.#success = value;
            if (this.#success)
                this.onsuccess();
        }
    }
   
    onsuccess() {
    }
    
   
    get inputs() {
        return this.#inputs;
    }
   
    onmatch(character) {
    }
   
    write(doc) {
        if (!doc)
            doc = document;
         
        if (this.success) {
            doc.write("Match");
            if (this.value !== null)
                doc.write(": " + this.value);
            doc.writeln();
        }
        else
            doc.writeln("No match");
    }
    
    set value(value) {
        this.#value = value;
    }
    
    get value() {
        return this.#value;
    }
}
class Character extends Match {
    #character;
   
    constructor(character) {
        super();
        this.#character = character;
    }
   
    match(character) {
        var matched =
            this.#character === character;
         
        if (matched) {
            this.onmatch(character);
            this.success = true;
        }
        else
            this.success = false;
         
        return matched;
    }
   
}
class Range extends Match {
    #minimum;
    #maximum;
    constructor(minimum, maximum) {
        super();
        this.#minimum = minimum;
        this.#maximum = maximum;
    }
   
    match(character) {
   
        var matched =
            (this.#minimum <= character) &&
            (this.#maximum >= character);
         
        if (matched) {
            this.onmatch(character);
            this.success = true;
        }
        else
            this.success = false;
      
        return matched;
    }
   
}
class Word extends Match {
    #index = 0;
    #word;
    constructor(word) {
        super();
        this.#word = word;
    }
   
    match(character) {
        var matched =
            this.#word[this.#index] ===
            character;
         
        if (matched)
        {
            this.onmatch(character);
            ++this.#index;
            if (this.#index === this.#word.length) {
                this.success = true;
            }
        }
        else
            this.success = false;
         
        return matched;
    }
   
   
}
class And extends Match {
   #index = 0;
   #matches = [];
   constructor(...inputs) {
      super(...inputs);
      if (this.inputs.length === 0) {
         this.success = false;
      }
   }
   
   match(character) {
      var item;
      var matched;
      
      do {
         item =
            this.inputs[this.#index];

         matched =
            item.match(character);
    
         if (matched)
             this.onmatch(character);
             
         if (item.success) {
         
            this.#matches.push(item);
         
            if (++this.#index  ===
                this.inputs.length)
            {
               this.success = true;
               break;
            }
         }
         else if (item.success == false)
         {
            this.success = false;
         }
         
      } while(item.success && !matched);
         
      return matched;
   }
   
   readEnd(success) {
      while(this.#index <
            this.inputs.length) {
         var item =
            this.inputs[this.#index];

         item.readEnd();
         
         if (item.success) {
            this.#matches.push(item);
            ++this.#index;
         }
         else {
            if (item.success === false)
               this.success = false;
            break;
         }
         
      }
      
      if (this.success === undefined &&
          this.#index ===
          this.inputs.length)
         this.success = true;
         
      super.readEnd();
      
   }
   
   get matches() {
      return this.#matches;
   }
   
}
class Or extends Match {
    #item;
    constructor(...inputs) {
        super(...inputs);
    }
   
    match(character) {
        var matched = false;
 
        for (var i in this.inputs)
        {
            var item = this.inputs[i];
            
            if (item.success === undefined) {
         
               if (item.match(character)) {
                  matched = true;
               }
                
               if (item.success) {
                  this.#item = item;
                  this.index = i;
                  this.success = true;
                  break;
               }
            
            }
        }
      
        if (matched)
            this.onmatch(character);
        else
            this.success = false;
         
        return matched;
    }
   
    readEnd() {
      
       for (var i in this.inputs)
       {
           var item = this.inputs[i];
           if (item.success != false) {
               item.readEnd();
               if (item.success) {
                   this.#item = item;
                   this.index = i;
                   this.success = true;
                   break;
               }
           }
       }
      
       super.readEnd();

    }
   
    get item() {
        return this.#item;
    }
}
class Not extends Match {
    #match;
    constructor(match) {
        super();
        this.#match = match;
    }
   
    match(character) {
      
        var matched =
            !this.#match.match(character);
      
        if (this.#match.success === false) {
            this.success = true;
        }
        else if (this.#match.success)
            this.success = false;

        if (matched)
           this.onmatch(character);
           
        return matched;
      
    }
   
}
class Optional extends Match {
   #match;
   constructor(match) {
      super();
      this.#match = match;
   }
   
   match(character) {
      var matched =
         this.#match.match(character);
          
      if (this.#match.success !=
          undefined) {
         this.success = true;
      }

      return matched;
   }
   
   readEnd() {
      this.success = true;
      super.readEnd();
   }
   
 
}
class Capture extends And {

    #object;
    #keys;

    constructor(object) {
        var objects;
        if (object instanceof Match) {
            object.value = null;
            object.onmatch = onmatch;
            objects = [object];
        }
        else
            objects = getObjects(object);
            
        super(...objects);
        
        this.#object = object;
        this.#keys = getKeys(object);
        this.onmatch = onmatch;
        
        function getObjects(object) {
            var objects = [];
            var keys = Object.keys(object);
            for (var index in keys) {
                var key = keys[index];
                var obj = object[key];
                if (obj instanceof Match) {
                    obj.value = null;
                    obj.onmatch = onmatch
                    objects.push(obj);
                }
                else {
                    objects.push(...getObjects(obj));
                }
            }
            return objects;
        }
        
        function getKeys(object) {
            var allKeys= [];
            if (object instanceof Match)
                return [
                    {
                        key: "value"
                    }
                ];
                
               
            var keys = Object.keys(object);
            for (var index in keys) {
                var key = keys[index];
                var obj = object[key];
                if (obj instanceof Match) {
                    allKeys.push(
                        {
                            key,
                            parent: object
                        }
                    );
                }
                else {
                    allKeys.push(...getKeys(obj));
                }
            }
            return allKeys;
        }
        
        function onmatch(character) {
            if (this.value === null)
                this.value = character;
            else
                this.value += character;
        }
    }
    
    readEnd() {

        if (this.success === undefined) {
            super.readEnd();
        }
        
        if (this.success)
            this.setValues();
        
    }
   
    setValues() {
        var i = 0;
        var object = this.#object;
        var keys = this.#keys;
        var matches = super.matches;
        
        // Single match, get its value
        if (matches.length === 1) {
            var item = matches[0];
            this.value = item.value;
            return;
        }
        
        // Multiple matches
        for (var index in matches) {
            var item = matches[index];
            var key = keys[index];
            var parent = key.parent;
            parent[key.key] = item.value;
        }

        this.value = {};
        Object.assign(this.value, object);
    }
    
 
}
class Repeat extends Match {
    #Match;
    #match;
    #items = [];
  
    constructor(Match) {
        super();
        this.#Match = Match;
        this.#match = new this.#Match();
      
    }
   
    match(character) {
   
        var matched =
            this.#match.match(character);
         
        if (matched)
           this.onmatch(character);
           
        if (this.#match.success) {
      
            this.#items.push(
                this.#match
            );
            
            this.#match =
               new this.#Match();
           
        }
        else if (this.#match.success ===
                 false)
        {
            this.checkSuccess();
            this.#match =
                new this.#Match();
        }
      
        return matched;
      
    }
   
    readEnd() {
        if (this.#match.success ===
            undefined)
        {
            this.#match.readEnd();
            if (this.#match.success) {

                this.#items.push(
                    this.#match
               );
            }
        }
        this.checkSuccess();
        super.readEnd();
    }
   
    checkSuccess() {
      
        if (this.#items.length > 0) {
            this.success = true;
        }
        else {
            this.success = false;
         }
    }
   
    get items() {
        return this.#items;
    }
   /*
   get value() {
      return this.items.map(
         item => {
            return item.value;
         }
      ).join("");
   }
   */
}
