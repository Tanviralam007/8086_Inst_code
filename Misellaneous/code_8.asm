;Take 3 characters from the user and print them in reverse order.
.MODEL SMALL
.STACK 100H

.DATA
    PROMPT      DB 'Enter 3 characters: $'
    OUTPUT_MSG  DB 0DH, 0AH, 'Characters in reverse order: $'
    NEWLINE     DB 0DH, 0AH, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Display prompt
    LEA DX, PROMPT
    MOV AH, 09H
    INT 21H

    ; Read 3 characters and push onto stack
    MOV CX, 3

READ_LOOP:
    MOV AH, 01H
    INT 21H        ; Character in AL
    PUSH AX        ; Push character onto stack
    LOOP READ_LOOP

    ; Print newline and output message
    LEA DX, OUTPUT_MSG
    MOV AH, 09H
    INT 21H

    ; Pop characters and display them
    MOV CX, 3

PRINT_LOOP:
    POP AX
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    LOOP PRINT_LOOP

    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN