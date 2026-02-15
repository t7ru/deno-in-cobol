       IDENTIFICATION DIVISION.
       PROGRAM-ID. DEMO.

           ENVIRONMENT DIVISION.
               INPUT-OUTPUT SECTION.
                   FILE-CONTROL.
                   SELECT OUTPUT-FILE-FD
                       ASSIGN TO DYNAMIC OUTPUT-FILE
                       ORGANIZATION IS LINE SEQUENTIAL.

           DATA DIVISION.
               FILE SECTION.
               FD  OUTPUT-FILE-FD
                   LABEL RECORDS ARE STANDARD.
               01  OUTPUT-FILE-REC    PIC X(200).

           WORKING-STORAGE SECTION.
               01  JS-CODE     PIC X(100) VALUE
                       "console.log('Eval Works!')".
               01  SCRIPT-FILE PIC X(100) VALUE "test/hello.js".
               01  RUN-FLAGS   PIC X(50)  VALUE "--allow-net".
               01  RUN-ARGS    PIC X(200) VALUE "arg1 arg2".
               01  DENO-CMD    PIC X(500) VALUE
                   "deno eval 'console.log(2 + 2)'".
               01  OUTPUT-FILE    PIC X(100) VALUE
                   "/tmp/deno-output.txt".
               01  EMPTY-ARGS     PIC X(200) VALUE SPACES.
               01  COMBINED-ARG   PIC X(50)  VALUE "combined-test".
               01  COMBINED-OUT   PIC X(120) VALUE
                   "/tmp/deno-combined.txt".
               01  EXPECTED-LINE  PIC X(100) VALUE "4".
               01  JS-QUOTES      PIC X(120) VALUE
                   "console.log('a ""b"" c')".
               01  STATUS-CODE PIC S9(4) COMP.
               01  RESULT-LINE PIC X(100).

           PROCEDURE DIVISION.
               *> 1. DENO-EVAL: Running inline code
               DISPLAY "--- Testing DENO-EVAL ---"
               CALL "DENO-EVAL" USING JS-CODE STATUS-CODE
               IF STATUS-CODE NOT = 0
                   DISPLAY "Eval Failed! Code: " STATUS-CODE
                   STOP RUN
               END-IF

               *> 2. DENO-RUN: Running a file without args
               DISPLAY "--- Testing DENO-RUN ---"
               CALL "DENO-RUN" USING
                   SCRIPT-FILE RUN-FLAGS EMPTY-ARGS STATUS-CODE
               IF STATUS-CODE NOT = 0
                   DISPLAY "Run Failed! Code: " STATUS-CODE
                   STOP RUN
               END-IF

               *> 3. DENO-RUN: Running a file with args
               DISPLAY "--- Testing DENO-RUN ---"
               CALL "DENO-RUN" USING
                   SCRIPT-FILE RUN-FLAGS RUN-ARGS STATUS-CODE
               IF STATUS-CODE NOT = 0
                   DISPLAY "Run Failed! Code: " STATUS-CODE
                   STOP RUN
               END-IF

               *> 4. DENO-CAPTURE: Capture output to file
               DISPLAY "--- Testing DENO-CAPTURE ---"
               CALL "DENO-CAPTURE" USING
                   DENO-CMD OUTPUT-FILE STATUS-CODE
               IF STATUS-CODE = 0
                   DISPLAY "Output captured to: " OUTPUT-FILE
                   OPEN INPUT OUTPUT-FILE-FD
                   READ OUTPUT-FILE-FD INTO RESULT-LINE
                   CLOSE OUTPUT-FILE-FD
                   IF FUNCTION TRIM(RESULT-LINE) NOT = EXPECTED-LINE
                       DISPLAY "Capture mismatch: got '"
                           FUNCTION TRIM(RESULT-LINE) "' expected '"
                               EXPECTED-LINE "'"
                       STOP RUN
                   ELSE
                       DISPLAY "Capture OK: " FUNCTION TRIM(RESULT-LINE)
                   END-IF
               ELSE
                   DISPLAY "Capture Failed! Code: " STATUS-CODE
                   STOP RUN
               END-IF

               *> 5. Run eval with embedded quotes
               DISPLAY "--- Testing QUOTED DENO-EVAL ---"
               CALL "DENO-EVAL" USING JS-QUOTES STATUS-CODE
               IF STATUS-CODE NOT = 0
                   DISPLAY "Quoted Eval Failed! Code: " STATUS-CODE
                   STOP RUN
               END-IF

               *> 6. Combined test
               DISPLAY "--- Testing COMBINED DENO-RUN ---"
               MOVE "--allow-net --allow-write --allow-read"
                   TO RUN-FLAGS
               MOVE SPACES TO RUN-ARGS
               STRING FUNCTION TRIM(COMBINED-ARG) " "
                   FUNCTION TRIM(COMBINED-OUT) DELIMITED BY SIZE
                       INTO RUN-ARGS
               CALL "DENO-RUN" USING
                   "test/fetchwrite.ts" RUN-FLAGS RUN-ARGS STATUS-CODE
               IF STATUS-CODE NOT = 0
                   DISPLAY "Combined Run Failed! Code: " STATUS-CODE
                   STOP RUN
               END-IF

               MOVE FUNCTION TRIM(COMBINED-OUT) TO OUTPUT-FILE
               OPEN INPUT OUTPUT-FILE-FD
               READ OUTPUT-FILE-FD INTO RESULT-LINE
               CLOSE OUTPUT-FILE-FD
               IF FUNCTION TRIM(RESULT-LINE) NOT = COMBINED-ARG
                   DISPLAY "Combined mismatch: got '"
                       FUNCTION TRIM(RESULT-LINE) "' expected '"
                           COMBINED-ARG "'"
                   STOP RUN
               ELSE
                   DISPLAY "Combined OK: " FUNCTION TRIM(RESULT-LINE)
               END-IF

               STOP RUN.
