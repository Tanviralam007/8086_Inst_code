;Conditional Logic (CASE structure):
;Question: Use a CASE structure to code the following:
;Read a character.
;If it's "A", then execute carriage return.
;If it's "B", then execute line feed.
;If it's any other character, then return to DOS.

.MODEL SMALL
.STACK 100H
.DATA

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Read a character from user
    MOV AH, 01H
    INT 21H            
    MOV BL, AL         

    ; Compare with 'A'
    CMP BL, 'A'
    JE CARRIAGE_RETURN

    ; Compare with 'B'
    CMP BL, 'B'
    JE LINE_FEED

    ; If not 'A' or 'B', return to DOS
    JMP EXIT

CARRIAGE_RETURN:
    MOV DL, 13         ; ASCII for carriage return
    MOV AH, 02H
    INT 21H
    JMP EXIT

LINE_FEED:
    MOV DL, 10         ; ASCII for line feed
    MOV AH, 02H
    INT 21H

EXIT:
    MOV AH, 4CH        ; DOS terminate program
    INT 21H

MAIN ENDP
END MAIN
