;Write a program thC!t prompts the user to enter a character, and
;on subsequent lines prints its ASCII code in binary, 
;and the number of 1 bits In Its ASCII code. 

.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'TYPE A CHARACTER: $'
    MSG2 DB 0DH,0AH, 'THE ASCII CODE OF $'
    MSG3 DB ' IN BINARY IS $'
    MSG4 DB 0DH,0AH, 'THE NUMBER OF 1 BITS IS $'
    NEWLINE DB 0DH,0AH,'$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Display prompt
    LEA DX, MSG1
    MOV AH, 09H
    INT 21H

    ; Read character
    MOV AH, 01H
    INT 21H           ; AL = character
    MOV BL, AL        ; Save input character in BL
    MOV DL, AL        ; Also save for shifting/bit-checking

    ; Print ASCII message
    LEA DX, MSG2
    MOV AH, 09H
    INT 21H

    ; Print the character
    MOV DL, BL
    MOV AH, 02H
    INT 21H

    ; Print binary message
    LEA DX, MSG3
    MOV AH, 09H
    INT 21H

    ; Binary printing setup
    MOV CL, BL        ; Copy original character to CL for shifting
    MOV BH, 0         ; Bit count (BH will count the 1s)
    MOV CH, 8         ; Bit count loop (CH used instead of CX to avoid 09h print issue)

SHOW_BITS:
    MOV DL, '0'
    TEST CL, 10000000b   ; Check MSB
    JZ PRINT_BIT
    MOV DL, '1'
    INC BH

PRINT_BIT:
    MOV AH, 02H
    INT 21H
    SHL CL, 1            ; Shift to check next bit
    DEC CH
    JNZ SHOW_BITS

    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

    ; Print number of 1 bits message
    LEA DX, MSG4
    MOV AH, 09H
    INT 21H

    ; Print BH (number of 1s)
    MOV DL, BH
    ADD DL, '0'          ; Convert to ASCII
    MOV AH, 02H
    INT 21H

    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
