# Deno in COBOL
Call and run Deno (JavaScript/TypeScript) from your COBOL programs because why not?!

## Installation
1. Copy `src/*.cbl` to your project
2. Compile with your program:
```bash
   cobc -x -o yourapp yourapp.cbl src/deno-*.cbl
```

## Usage

### DENO-EVAL
Evaluate inline code:
```cobol
CALL "DENO-EVAL" USING "console.log('hello')" STATUS-CODE
```

### DENO-RUN
Execute a script with optional flags and arguments:
```cobol
CALL "DENO-RUN" USING 
     "script.ts" "--allow-net" "arg1 arg2" STATUS-CODE
```

### DENO-CAPTURE
Execute any Deno command and save output to a file:
```cobol
CALL "DENO-CAPTURE" USING 
     "deno eval 'console.log(2+2)'" "/tmp/out.txt" STATUS-CODE
```

## License
[MIT](LICENSE)
