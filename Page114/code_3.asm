;Write a sequence of instructions to put the sum 100+95+90+…+5 in AX.
;First term a = 100
;Common difference d = -5
;Last term l = 5

;We can compute the number of terms n:
;l=a+(n-1)d
;5=100+(n-1)(-5)
;5=100-5(n-1)
;5=100-5n+5
;5n=100
;n=20
;S = n/2 * (first_term + last_term)
;S = 20/2 * (100 + 5) = 10 * 105 = 1050

.MODEL SMALL
.STACK 100H
.DATA

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AX, 0       ; AX will hold the sum
    MOV BX, 100     ; Starting term

SUM_LOOP:
    ADD AX, BX      ; Add current term to sum
    SUB BX, 5       ; Next term in the sequence
    CMP BX, 4       ; Stop if BX < 5
    JA SUM_LOOP     ; Jump if BX > 4 (i.e., BX >= 5)

    ; AX now contains the sum = 1050

    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN


;Using LOOP instruction
.MODEL SMALL
.STACK 100H
.DATA

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AX, 0       ; AX = sum
    MOV BX, 100     ; Start of series
    MOV CX, 20      ; 20 terms

SUM_LOOP:
    ADD AX, BX      ; Add current term
    SUB BX, 5       ; Decrease by 5
    LOOP SUM_LOOP   ; Repeat until CX = 0

    ; AX = 1050

    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN

