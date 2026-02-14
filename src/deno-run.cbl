       IDENTIFICATION DIVISION.
       PROGRAM-ID. DENO-RUN.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  CMD-BUFFER      PIC X(300).
       01  RET-VAL         PIC S9(4) COMP.

       LINKAGE SECTION.
       01  FILE-PATH       PIC X(100).
       01  FLAGS           PIC X(50).
       01  STATUS-CODE     PIC S9(4) COMP.

       PROCEDURE DIVISION USING FILE-PATH FLAGS STATUS-CODE.
           MOVE SPACES TO CMD-BUFFER
           STRING "deno run "              DELIMITED BY SIZE
                  FUNCTION TRIM(FLAGS)     DELIMITED BY SIZE
                  " '"                     DELIMITED BY SIZE
                  FUNCTION TRIM(FILE-PATH) DELIMITED BY SIZE
                  "'"                      DELIMITED BY SIZE
                  INTO CMD-BUFFER

           CALL "SYSTEM" USING CMD-BUFFER RETURNING RET-VAL
           MOVE RET-VAL TO STATUS-CODE
           EXIT PROGRAM.
