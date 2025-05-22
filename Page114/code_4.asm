;Employ LOOP instructions to put the sum of the 
;first 50 terms of the arithmetic sequence 1,5,9,13,… in DX.
;First term a = 1
;Common difference d = 4
;Number of terms n = 50

;sum=n/2*(2a+(n-1)*d)
;sum=50/2*(2*1+49*4)
;sum=25*(2+196)
;sum=25*198
;sum=4950

.MODEL SMALL
.STACK 100H
.DATA

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV CX, 50      ; Number of terms
    MOV BX, 1       ; Starting term of the sequence
    XOR DX, DX      ; Clear DX to hold the sum

SUM_LOOP:
    ADD DX, BX      ; Add current term to sum
    ADD BX, 4       ; Next term in the sequence (BX = BX + 4)
    LOOP SUM_LOOP   ; Decrement CX, loop if not zero

    ; DX now contains sum = 4950

    MOV AH, 4CH     
    INT 21H
MAIN ENDP
END MAIN
