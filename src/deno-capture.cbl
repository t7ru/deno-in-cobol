       IDENTIFICATION DIVISION.
       PROGRAM-ID. DENO-CAPTURE.

       DATA DIVISION.
           WORKING-STORAGE SECTION.
               01  CMD-BUFFER      PIC X(800).
               01  RET-VAL         PIC S9(4) COMP.

       LINKAGE SECTION.
               01  DENO-CMD    PIC X(500).
               01  OUTPUT-FILE     PIC X(100).
               01  STATUS-CODE     PIC S9(4) COMP.

       PROCEDURE DIVISION USING DENO-CMD OUTPUT-FILE STATUS-CODE.
           MOVE SPACES TO CMD-BUFFER
           STRING FUNCTION TRIM(DENO-CMD)     DELIMITED BY SIZE
                   " > "                      DELIMITED BY SIZE
                   FUNCTION TRIM(OUTPUT-FILE) DELIMITED BY SIZE
                   " 2>&1"                    DELIMITED BY SIZE
                   INTO CMD-BUFFER

           CALL "SYSTEM" USING CMD-BUFFER RETURNING RET-VAL
           MOVE RET-VAL TO STATUS-CODE
           EXIT PROGRAM.
