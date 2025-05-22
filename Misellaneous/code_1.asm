;Take a single-digit from the user. 
;Display it as binary and show the message like "You entered: 1" in a new line.

.MODEL SMALL
.STACK 100H

.DATA
    MSG_PROMPT   DB 'Enter a single digit (0-9): $'
    MSG_NEWLINE  DB 0DH, 0AH, '$'
    MSG_OUTPUT   DB 'You entered: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, MSG_PROMPT
    MOV AH, 09H
    INT 21H

    ; Read character from user (digit)
    MOV AH, 01H
    INT 21H         ; AL = ASCII digit (e.g., '5')
    MOV BL, AL      ; Save original ASCII
    SUB AL, '0'     ; Convert ASCII to number (0–9)
    MOV CL, AL      ; Store numeric value in CL

    ; Convert to binary and display
    MOV CH, 8       ; 8 bits to show
    
    ; Newline for printing the binary number
    LEA DX, MSG_NEWLINE
    MOV AH, 09H
    INT 21H
    
BIN_PRINT:
    MOV DL, '0'
    TEST CL, 10000000b
    JZ SKIP_ONE
    MOV DL, '1'
SKIP_ONE:
    MOV AH, 02H
    INT 21H
    SHL CL, 1
    DEC CH
    JNZ BIN_PRINT

    ; Newline
    LEA DX, MSG_NEWLINE
    MOV AH, 09H
    INT 21H

    ; Show message: "You entered: <digit>"
    LEA DX, MSG_OUTPUT
    MOV AH, 09H
    INT 21H

    MOV DL, BL        ; Show original ASCII digit
    MOV AH, 02H
    INT 21H

    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
