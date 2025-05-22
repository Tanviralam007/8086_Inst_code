;Write a program thC!t prompts the user to enter a character, 
;and on subsequent lines prints its ASCII code in binary, 
;and the number of 1 bits and number of 0 bits In Its ASCII code.

.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'TYPE A CHARACTER: $'
    MSG2 DB 0DH,0AH, 'THE ASCII CODE OF $'
    MSG3 DB ' IN BINARY IS $'
    MSG4 DB 0DH,0AH, 'THE NUMBER OF 1 BITS IS $'
    MSG5 DB 0DH,0AH, 'THE NUMBER OF 0 BITS IS $'
    NEWLINE DB 0DH,0AH,'$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Prompt user to enter character
    LEA DX, MSG1
    MOV AH, 09H
    INT 21H

    ; Read the character
    MOV AH, 01H
    INT 21H           ; AL = input character
    MOV BL, AL        ; Save input character
    MOV CL, AL        ; Copy to CL for bit shifting

    ; Print "THE ASCII CODE OF <char> IN BINARY IS"
    LEA DX, MSG2
    MOV AH, 09H
    INT 21H

    MOV DL, BL        ; Output the character itself
    MOV AH, 02H
    INT 21H

    LEA DX, MSG3
    MOV AH, 09H
    INT 21H

    ; Show binary
    MOV CH, 8         ; Loop counter for 8 bits
    MOV BH, 0         ; Count of 1s

SHOW_BITS:
    MOV DL, '0'       
    TEST CL, 10000000b
    JZ PRINT_BIT
    MOV DL, '1'
    INC BH

PRINT_BIT:
    MOV AH, 02H
    INT 21H
    SHL CL, 1
    DEC CH
    JNZ SHOW_BITS

    ; Newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

    ; Print message: THE NUMBER OF 1 BITS IS
    LEA DX, MSG4
    MOV AH, 09H
    INT 21H

    ; Convert BH to ASCII
    MOV DL, BH
    ADD DL, '0'
    MOV AH, 02H
    INT 21H

    ; Print message: THE NUMBER OF 0 BITS IS
    LEA DX, MSG5
    MOV AH, 09H
    INT 21H

    ; 0 bits = 8 - BH
    MOV AL, 8
    SUB AL, BH
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
