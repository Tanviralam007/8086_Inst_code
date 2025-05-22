;Write a program to display a "?", 
;read two capital letters, and display them on the next line 
;In alphabetical order. 

 .MODEL SMALL
.STACK 100H
.DATA
    NEWLINE DB 0DH, 0AH, '$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ;Display '?'
    MOV DL, '?'
    MOV AH, 02H
    INT 21H

    ; Read first capital letter
    MOV AH, 01H
    INT 21H          ; AL = first char
    MOV BL, AL       ; save in BL

    ; Read second capital letter
    MOV AH, 01H
    INT 21H          ; AL = second char
    MOV BH, AL       ; save in BH

    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

    ; Compare BL and BH to decide order
    MOV AL, BL
    CMP AL, BH
    JBE PRINT_ORDER   ; if BL <= BH jump to print in order

    ; Swap if BL > BH
    MOV AL, BL
    MOV BL, BH
    MOV BH, AL

PRINT_ORDER:
    ; Print BL
    MOV DL, BL
    MOV AH, 02H
    INT 21H

    ; Print BH
    MOV DL, BH
    MOV AH, 02H
    INT 21H

    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
