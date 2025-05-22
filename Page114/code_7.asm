;EVEN NUMBER | ODD NUMBER CHECK
.MODEL SMALL
.STACK 100H
.DATA
    msgEven DB 'Number is EVEN$', 13, 10, '$'
    msgOdd  DB 'Number is ODD$',  13, 10, '$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AL, 12 ; EXAMPLE EVEN NUMBER       
    
    TEST AL, 1       ; Check LSB
    JZ IS_EVEN       ; Jump if zero (even)
    
    ; If odd
    MOV DX, OFFSET msgOdd
    MOV AH, 09H
    INT 21H
    JMP DONE

IS_EVEN:
    LEA DX, msgEven
    MOV AH, 09H
    INT 21H

DONE:
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN

;Write an assembly code sum only even numbers 0-100
.MODEL SMALL
.STACK 100H
.DATA
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV CX, 51      ; Number of even numbers between 0 and 100 (inclusive)
    MOV BX, 0       ; Current even number (start at 0)
    MOV AX, 0       ; Accumulator for sum

SUM_LOOP:
    ADD AX, BX      ; Add current even number to sum
    ADD BX, 2       ; Next even number (increment by 2)
    LOOP SUM_LOOP

    ; Now AX contains the sum of even numbers 0 + 2 + 4 + ... + 100 = 2550

    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN

;Write a assembly code sum only odd numbers 0-100
.MODEL SMALL
.STACK 100H
.DATA
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV CX, 50      ; Number of odd numbers between 1 and 99 inclusive (1,3,5,...,99)
    MOV BX, 1       ; Current even number (start at 1)
    MOV AX, 0       ; Accumulator for sum

SUM_LOOP:
    ADD AX, BX      ; Add current even number to sum
    ADD BX, 2       ; Next even number (increment by 2)
    LOOP SUM_LOOP

     ; AX now contains sum of odd numbers from 1 to 99 sum = 2500

    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN

