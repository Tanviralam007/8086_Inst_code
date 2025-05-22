;Take a character and convert uppercase to lowercase or vice versa
.MODEL SMALL
.STACK 100H

.DATA
    PROMPT      DB 'Enter a character: $'
    NEWLINE     DB 0DH, 0AH, '$'
    MSG_OUTPUT  DB 0DH, 0AH, 'Converted character: $'
    MSG_UPPER   DB 0DH, 0AH, 'Uppercase to lowercase $'
    MSG_LOWER   DB 0DH, 0AH,'Lowercase to uppercase $'
    MSG_NOT_LETTER DB 0DH, 0AH, 'Not a letter - no conversion needed $'
    CONTINUE_MSG DB 'Press Enter to continue or any other key + Enter to exit $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

MAIN_LOOP:
    LEA DX, PROMPT
    MOV AH, 09H
    INT 21H

    ; Read character
    MOV AH, 01H
    INT 21H
    MOV BL, AL          ; Store input character in BL

    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

    ; Check if uppercase letter (A-Z)
    CMP BL, 'A'
    JB CHECK_LOWERCASE
    CMP BL, 'Z'
    JA CHECK_LOWERCASE
    
    ; Convert uppercase to lowercase
    LEA DX, MSG_UPPER
    MOV AH, 09H
    INT 21H
    
    LEA DX, MSG_OUTPUT
    MOV AH, 09H
    INT 21H
    
    MOV DL, BL
    ADD DL, 20H         ; Add 32 to convert uppercase to lowercase
    MOV AH, 02H
    INT 21H
    JMP SHOW_CONTINUE

CHECK_LOWERCASE:
    ; Check if lowercase letter (a-z)
    CMP BL, 'a'
    JB NOT_LETTER
    CMP BL, 'z'
    JA NOT_LETTER
    
    ; Convert lowercase to uppercase
    LEA DX, MSG_LOWER
    MOV AH, 09H
    INT 21H
    
    LEA DX, MSG_OUTPUT
    MOV AH, 09H
    INT 21H
    
    MOV DL, BL
    SUB DL, 20H         ; Subtract 32 to convert lowercase to uppercase
    MOV AH, 02H
    INT 21H
    JMP SHOW_CONTINUE

NOT_LETTER:
    ; Character is not a letter
    LEA DX, MSG_NOT_LETTER
    MOV AH, 09H
    INT 21H
    
    MOV DL, BL          ; Display the same character
    MOV AH, 02H
    INT 21H

SHOW_CONTINUE:
    ; Print newlines
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    
    ; Ask if user wants to continue
    LEA DX, CONTINUE_MSG
    MOV AH, 09H
    INT 21H
    
    ; Read user choice
    MOV AH, 01H
    INT 21H
    
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    
    ; Check if Enter key (continue) or other key (exit)
    CMP AL, 0DH
    JE MAIN_LOOP        
    
    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN