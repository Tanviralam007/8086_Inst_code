;Write a program that prompts the user to enter a character and
;prints the ASCII code of the character in hex on the next line. 
;Repeat this process until the user types a carriage return.

;Sample execution:
;TYPE A CHARACTER: Z
;THE ASCII CODE OF Z IN HEX IS 5A
;TYPE A CHARACTER: 

.MODEL SMALL
.STACK 100H
.DATA
    PROMPT_MSG DB 'TYPE A CHARACTER: $'
    ASCII_MSG DB 0DH, 0AH, 'THE ASCII CODE OF $'
    HEX_MSG DB ' IN HEX IS $'
    NEWLINE DB 0DH, 0AH, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
MAIN_LOOP:
    LEA DX, PROMPT_MSG
    MOV AH, 09H
    INT 21H
    
    ; Read character
    MOV AH, 01H
    INT 21H
    
    ; Check if carriage return (Enter key)
    CMP AL, 0DH
    JE EXIT_PROGRAM
    
    ; Save the character
    MOV BL, AL
    
    ; Display ASCII message
    LEA DX, ASCII_MSG
    MOV AH, 09H
    INT 21H
    
    ; Display the character
    MOV DL, BL
    MOV AH, 02H
    INT 21H
    
    ; Display hex message
    LEA DX, HEX_MSG
    MOV AH, 09H
    INT 21H
    
    ; Convert and display ASCII value in hex
    MOV AL, BL          ; Get the character back
    CALL DISPLAY_HEX    ; Display as hex
    
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    
    JMP MAIN_LOOP       ; Repeat the process
    
EXIT_PROGRAM:
    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; Procedure to display AL in hexadecimal
DISPLAY_HEX PROC
    ; Display upper nibble (4 bits)
    MOV CL, AL          ; Save original value
    SHR AL, 4           ; Shift right 4 bits to get upper nibble
    CALL HEX_DIGIT      ; Convert and display
    
    ; Display lower nibble (4 bits)
    MOV AL, CL          ; Restore original value
    AND AL, 0FH         ; Mask upper nibble, keep lower 4 bits
    CALL HEX_DIGIT      ; Convert and display
    
    RET
DISPLAY_HEX ENDP

; Procedure to convert a single hex digit (0-F) and display it
HEX_DIGIT PROC
    CMP AL, 9           ; Check if digit is 0-9 or A-F
    JLE NUMERIC         ; If <= 9, it's numeric
    
    ; It's A-F
    ADD AL, 'A' - 10    ; Convert 10-15 to 'A'-'F'
    JMP DISPLAY_DIGIT
    
NUMERIC:
    ADD AL, '0'         ; Convert 0-9 to '0'-'9'
    
DISPLAY_DIGIT:
    MOV DL, AL          ; Move to DL for display
    MOV AH, 02H         ; Display character function
    INT 21H
    
    RET
HEX_DIGIT ENDP

END MAIN