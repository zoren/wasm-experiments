function instantiatePromise(responsePromise, importObject) {
    if(WebAssembly.instantiateStreaming) {
        return WebAssembly.instantiateStreaming(responsePromise, importObject);
    }
    return responsePromise.then(response =>
        response.arrayBuffer()
        ).then(bytes => WebAssembly.instantiate(bytes, importObject));
}

function doIt(input) {
    var inputIndex = 0;

    var importObject = {
        imports: {
            put_char : arg => console.log(String.fromCharCode(arg)),
            get_char : () => inputIndex<input.length ? input.charCodeAt(inputIndex++) : 0
        }
    };

    const wasmUrl = '../out/lex.wasm';

    instantiatePromise(fetch(wasmUrl), importObject).then(results => {
        instance = results.instance;
        document.getElementById("container").textContent = instance.exports.main();
      }).catch(console.error);
}
