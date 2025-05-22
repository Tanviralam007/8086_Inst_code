;Write a sequence of instructions to put the sum in AX
;1 + 4 + 7 + ... + 148
;First term a = 1
;Common difference d = 3
;Last term l = 148

;l = a + (n - 1) * d
;148 = 1 + (n - 1) * 3
;=> (n - 1) * 3 = 147
;=> n - 1 = 49
;=> n = 50

;Now the sum of n terms is:
;S = n/2 * (first_term + last_term)
;S = 50/2 * (1 + 148) = 25 * 149 = 3725

.MODEL SMALL
.STACK 100H
.DATA

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AX, 0       ; AX will hold the sum
    MOV BX, 1       ; BX holds the current term (starts at 1)

SUM_LOOP:
    ADD AX, BX      ; Add current term to AX
    ADD BX, 3       ; Next term in the sequence
    CMP BX, 149     ; Check if BX <= 148
    JBE SUM_LOOP    ; Jump if BX is still in the sequence

    ; Now AX contains the sum = 3725

    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN

; Using LOOP Instruction
.MODEL SMALL
.STACK 100H
.DATA

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AX, 0       ; AX holds the sum
    MOV BX, 1       ; BX is the current term in the series
    MOV CX, 50      ; Number of terms

SUM_LOOP:
    ADD AX, BX      ; Add current term to AX
    ADD BX, 3       ; Next term in the sequence
    LOOP SUM_LOOP   ; Loop until CX = 0

    ; AX now contains the result: 3725

    MOV AH, 4CH     ; Return to DOS
    INT 21H

MAIN ENDP
END MAIN
