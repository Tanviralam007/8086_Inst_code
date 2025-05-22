;Assume AL contains a binary number. Count how many 1s are there.
.MODEL SMALL
.STACK 100H

.DATA
    MSG      DB 'Number of 1s are: $'
    NEWLINE  DB 0DH, 0AH, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Example binary number
    MOV AL, 11001010B     

    MOV CL, 8             ; 8 bits to check
    XOR BL, BL            ; BL = 0 (count of 1s)

COUNT_LOOP:
    TEST AL, 10000000B    ; Check MSB
    JZ SKIP_INC
    INC BL                ; If 1, increment count

SKIP_INC:
    SHL AL, 1             ; Shift left to check next bit
    DEC CL
    JNZ COUNT_LOOP

    ; Display message
    LEA DX, MSG
    MOV AH, 09H
    INT 21H

    ; Convert count to ASCII and display
    MOV DL, BL
    ADD DL, '0'
    MOV AH, 02H
    INT 21H

    ; Newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
