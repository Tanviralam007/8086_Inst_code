;Take a decimal digit from user (0-9), check whether it is odd or even
.MODEL SMALL
.STACK 100H

.DATA
    PROMPT      DB 'Enter a decimal digit (0-9): $'
    INVALID     DB 0DH,0AH, 'Invalid input!$'
    EVEN_MSG    DB 0DH,0AH, 'Even$'
    ODD_MSG     DB 0DH,0AH, 'Odd$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, PROMPT
    MOV AH, 09H
    INT 21H

    ; Get input character
    MOV AH, 01H
    INT 21H        ; AL = character

    ; Validate if it’s a digit (0-9)
    CMP AL, '0'
    JB INVALID_INPUT
    CMP AL, '9'
    JA INVALID_INPUT

    ; Convert ASCII to number (0–9)
    SUB AL, '0'

    ; Test LSB for odd/even using TEST
    TEST AL, 1
    JZ SHOW_EVEN

SHOW_ODD:
    LEA DX, ODD_MSG
    JMP SHOW_MSG

SHOW_EVEN:
    LEA DX, EVEN_MSG

SHOW_MSG:
    MOV AH, 09H
    INT 21H
    JMP EXIT

INVALID_INPUT:
    LEA DX, INVALID
    MOV AH, 09H
    INT 21H

EXIT:
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
