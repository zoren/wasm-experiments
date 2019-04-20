const fs = require('fs');

const wasmUrl = 'out/lex.wasm';
var source = fs.readFileSync(wasmUrl);
var typedArray = new Uint8Array(source);

function doIt(input) {
    var inputIndex = 0;

    var importObject = {
        imports: {
            put_char : arg => process.stdout.write(String.fromCharCode(arg)),
            get_char : () => inputIndex < input.length ? input.charCodeAt(inputIndex++) : -1
        }
    };

    WebAssembly.instantiate(typedArray, importObject).then(results => {
        instance = results.instance;
        instance.exports.main();
      }).catch(console.error);
}
doIt("abzABZ123:@#@#!");
