;Take a character as input and display its ASCII value in decimal.
.MODEL SMALL
.STACK 100H

.DATA
    PROMPT      DB 'Enter a character: $'
    MSG_OUTPUT  DB 0DH, 0AH, 'ASCII value: $'
    NEWLINE     DB 0DH, 0AH, '$'
    DIGITS      DB 3 DUP(?)      ; Store up to 3 decimal digits

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, PROMPT
    MOV AH, 09H
    INT 21H

    ; Read a character
    MOV AH, 01H
    INT 21H         ; AL = character

    ; Save ASCII value in AX
    MOV AH, 0
    MOV CX, 10      ; Divisor
    MOV SI, OFFSET DIGITS + 2  ; Point to the end of DIGITS array

CONVERT_LOOP:
    XOR DX, DX
    DIV CX          ; AX ÷ 10 ? AL = quotient, DL = remainder
    ADD DL, '0'     ; Convert remainder to ASCII
    DEC SI
    MOV [SI], DL
    CMP AX, 0
    JNZ CONVERT_LOOP

    ; Show message
    LEA DX, MSG_OUTPUT
    MOV AH, 09H
    INT 21H

    ; Print converted digits
    MOV DI, SI
PRINT_LOOP:
    MOV DL, [DI]
    MOV AH, 02H
    INT 21H
    INC DI
    CMP DI, OFFSET DIGITS + 3
    JB PRINT_LOOP

    ; Newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
