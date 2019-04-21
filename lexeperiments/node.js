const fs = require('fs');

const wasmUrl = 'out/lex.wasm';
var source = fs.readFileSync(wasmUrl);
var typedArray = new Uint8Array(source);

async function doIt(input) {
    var inputIndex = 0;
    var output = ""
    var importObject = {
        imports: {
            put_char : arg => output += String.fromCharCode(arg),
            get_char : () => inputIndex < input.length ? input.charCodeAt(inputIndex++) : -1
        }
    };

    return WebAssembly.instantiate(typedArray, importObject).then(results => {
        instance = results.instance;
        instance.exports.main();
        return output;
      });
}
doIt(" 123ascABCæ").then(x => process.stdout.write(x)).catch(x => process.stderr.write(x));
