       IDENTIFICATION DIVISION.
       PROGRAM-ID. DENO-EVAL.

       DATA DIVISION.
           WORKING-STORAGE SECTION.
               01  CMD-BUFFER      PIC X(300).
               01  ESCAPED-JS      PIC X(200).
               01  JS-IDX          PIC 9(3).
               01  ESC-IDX         PIC 9(3).
               01  JS-CHAR         PIC X.
               01  RET-VAL         PIC S9(4) COMP.

       LINKAGE SECTION.
               01  JS-CODE         PIC X(100).
               01  STATUS-CODE     PIC S9(4) COMP.

       PROCEDURE DIVISION USING JS-CODE STATUS-CODE.
           MOVE SPACES TO CMD-BUFFER
           MOVE SPACES TO ESCAPED-JS
           MOVE 1 TO ESC-IDX

           PERFORM VARYING JS-IDX FROM 1 BY 1
               UNTIL JS-IDX > FUNCTION LENGTH(FUNCTION TRIM(JS-CODE))
               MOVE JS-CODE(JS-IDX:1) TO JS-CHAR
               IF JS-CHAR = "\" OR JS-CHAR = """"
                   MOVE "\" TO ESCAPED-JS(ESC-IDX:1)
                   ADD 1 TO ESC-IDX
               END-IF
               MOVE JS-CHAR TO ESCAPED-JS(ESC-IDX:1)
               ADD 1 TO ESC-IDX
           END-PERFORM

           STRING "deno eval "               DELIMITED BY SIZE
                   """"                      DELIMITED BY SIZE
                   FUNCTION TRIM(ESCAPED-JS) DELIMITED BY SIZE
                   """"                      DELIMITED BY SIZE
                   INTO CMD-BUFFER

           CALL "SYSTEM" USING CMD-BUFFER RETURNING RET-VAL
           MOVE RET-VAL TO STATUS-CODE
           EXIT PROGRAM.
