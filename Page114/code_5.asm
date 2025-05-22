;Use LOOP instructions to:
;Read a single character from the user
;Then display that character 80 times on the next line

.MODEL SMALL
.STACK 100H
.DATA
    NEWLINE DB 0DH, 0AH, '$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ;Read character from user
    MOV AH, 01H       
    INT 21H           
    MOV BL, AL        
    
    ;Print newline (carriage return + line feed)
    MOV DX, OFFSET NEWLINE   
    MOV AH, 09H       
    INT 21H           
    
    ;Print character 80 times using LOOP
    MOV CX, 80        ; Repeat count (80 times)

PRINT_LOOP:
    MOV AH, 02H       ; DOS print character function
    MOV DL, BL        ; DL = character to print (from BL)
    INT 21H           ; Print the character
    LOOP PRINT_LOOP   ; Repeat until CX = 0
    
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN