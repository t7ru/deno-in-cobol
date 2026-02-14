       IDENTIFICATION DIVISION.
       PROGRAM-ID. DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  JS-CODE     PIC X(100) VALUE "console.log('Eval Works!')".
       01  SCRIPT-FILE PIC X(100) VALUE "example/hello.ts".
       01  RUN-FLAGS   PIC X(50)  VALUE "--allow-net".
       01  STATUS-CODE PIC S9(4) COMP.

       PROCEDURE DIVISION.
           *> 1. Test DENO-EVAL (Running a raw string)
           DISPLAY "--- Testing DENO-EVAL ---"
           CALL "DENO-EVAL" USING JS-CODE STATUS-CODE
           IF STATUS-CODE NOT = 0
               DISPLAY "Eval Failed! Code: " STATUS-CODE
           END-IF

           *> 2. Test DENO-RUN (Running a file)
           DISPLAY "--- Testing DENO-RUN ---"
           CALL "DENO-RUN" USING SCRIPT-FILE RUN-FLAGS STATUS-CODE
           IF STATUS-CODE NOT = 0
               DISPLAY "Run Failed! Code: " STATUS-CODE
           END-IF

           STOP RUN.
