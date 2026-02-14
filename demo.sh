#!/bin/bash
cobc -x -o demo test/demo.cbl src/deno-run.cbl src/deno-eval.cbl src/deno-capture.cbl
./demo
