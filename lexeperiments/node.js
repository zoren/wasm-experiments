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
        try {
            instance.exports.main();
            return output;
        } catch (error) {
            throw [error, output];
        }

//        const memory = new Uint8Array(instance.exports.mem.buffer, 0, 20);
//        process.stdout.write(memory.toString());
//        process.stdout.write("\n");
      });
}
const test = "\"a b\" i32 12345 -1 (local.get $c) a1234567";
doIt(test).then(x => process.stdout.write(x)).catch(args => {process.stdout.write(args[1]);
    console.log(args[0]);} );
