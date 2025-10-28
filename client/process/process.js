function createProcess(path) {
    var process = await authentication.fetch(path);
    var inputKeys = Object.keys(process.inputs);
    var inputs = [];
    for (var keyIndex in inputKeys) {
        var key = inputKeys[keyIndex];
        var defaultValue = process.inputs[key];
        var input = key;
        if (defaultValue != undefined)
            input +=
                " = " +
                JSON.stringify(defaultValue);
        inputs.push(input);
    }
    
    var f = new Function(
        ...inputs,
        "return 1"
    );
    
    return f;
}