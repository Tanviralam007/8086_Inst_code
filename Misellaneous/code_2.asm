;Take a hex digit (0-9 or A-F) from the user and print the same digit back using stack
.MODEL SMALL
.STACK 100H

.DATA
    PROMPT      DB 'Enter a hex digit (0-9 or A-F or a-f): $'
    NEWLINE     DB 0DH, 0AH, '$'
    MSG_OUTPUT  DB 'You entered: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Show prompt
    LEA DX, PROMPT
    MOV AH, 09H
    INT 21H

    ; Read single character
    MOV AH, 01H
    INT 21H         ; AL = user input

    PUSH AX         ; Push input onto the stack

    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

    ; Show message
    LEA DX, MSG_OUTPUT
    MOV AH, 09H
    INT 21H

    ; Pop value from stack
    POP AX          ; AL = input character again

    MOV DL, AL
    MOV AH, 02H
    INT 21H

    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
