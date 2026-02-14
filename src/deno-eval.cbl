       IDENTIFICATION DIVISION.
       PROGRAM-ID. DENO-EVAL.

       DATA DIVISION.
           WORKING-STORAGE SECTION.
               01  CMD-BUFFER      PIC X(300).
               01  RET-VAL         PIC S9(4) COMP.

       LINKAGE SECTION.
               01  JS-CODE         PIC X(100).
               01  STATUS-CODE     PIC S9(4) COMP.

       PROCEDURE DIVISION USING JS-CODE STATUS-CODE.
           MOVE SPACES TO CMD-BUFFER
           STRING "deno eval "            DELIMITED BY SIZE
                   '"'                    DELIMITED BY SIZE
                   FUNCTION TRIM(JS-CODE) DELIMITED BY SIZE
                   '"'                    DELIMITED BY SIZE
                   INTO CMD-BUFFER

           CALL "SYSTEM" USING CMD-BUFFER RETURNING RET-VAL
           MOVE RET-VAL TO STATUS-CODE
           EXIT PROGRAM.
