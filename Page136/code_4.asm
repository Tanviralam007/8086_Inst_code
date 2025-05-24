;Write a program that prompts the user to type a binary number 
;of 16 digits or less, and outputs it in hex on the next line. If the
;user enters an illegal character, he or she should be prompted to begin again.
;Sample execution: 
;TYPE A BINARY NUMBER, UP TO 16 DIGITS: 11100001
;IN HEX IT IS E1

.MODEL SMALL
.STACK 100H
.DATA
    PROMPT_MSG DB 'TYPE A BINARY NUMBER, UP TO 16 DIGITS: $'
    HEX_MSG DB 0DH, 0AH, 'IN HEX IT IS $'
    ERROR_MSG DB 0DH, 0AH, 'INVALID CHARACTER! PLEASE TRY AGAIN.', 0DH, 0AH, '$'
    NEWLINE DB 0DH, 0AH, '$'
    BINARY_BUFFER DB 17 DUP(0)  ; Buffer to store binary digits + null terminator
    DIGIT_COUNT DB 0            ; Count of valid binary digits entered

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
RESTART:
    LEA DX, PROMPT_MSG
    MOV AH, 09H
    INT 21H
    
    ; Initialize for input
    LEA SI, BINARY_BUFFER
    MOV DIGIT_COUNT, 0
    
INPUT_LOOP:
    ; Read character
    MOV AH, 01H
    INT 21H
    
    ; Check for Enter key (end of input)
    CMP AL, 0DH
    JE CONVERT_TO_HEX
    
    ; Check if it's a valid binary digit (0 or 1)
    CMP AL, '0'
    JE VALID_DIGIT
    CMP AL, '1'
    JE VALID_DIGIT
    
    ; Invalid character - display error and restart
    LEA DX, ERROR_MSG
    MOV AH, 09H
    INT 21H
    JMP RESTART
    
VALID_DIGIT:
    ; Check if we've reached 16 digit limit
    CMP DIGIT_COUNT, 16
    JGE INPUT_LOOP      ; Ignore extra digits
    
    ; Store the digit
    MOV [SI], AL
    INC SI
    INC DIGIT_COUNT
    JMP INPUT_LOOP
    
CONVERT_TO_HEX:
    ; Check if at least one digit was entered
    CMP DIGIT_COUNT, 0
    JE RESTART
    
    ; Display hex message
    LEA DX, HEX_MSG
    MOV AH, 09H
    INT 21H
    
    ; Convert binary to hex and display
    CALL BINARY_TO_HEX
    
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    
    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; Procedure to convert binary string to hex and display
BINARY_TO_HEX PROC
    ; Start from the beginning of the binary string
    MOV CL, DIGIT_COUNT
    MOV CH, 0
    LEA SI, BINARY_BUFFER
    
    MOV AX, 0           ; Will hold our accumulated value
    
    ; Convert binary string to number using Horner's method
CONVERT_LOOP:
    CMP CX, 0
    JE DISPLAY_RESULT
    
    ; Multiply current result by 2
    SHL AX, 1
    
    ; Get current binary digit
    MOV BL, [SI]
    SUB BL, '0'         ; Convert ASCII to number
    
    ; Add current bit to result
    ADD AL, BL
    
    INC SI              ; Move to next digit
    DEC CX
    JMP CONVERT_LOOP
    
DISPLAY_RESULT:
    ; AX now contains the binary number converted to decimal
    ; Convert to hex and display
    CALL DISPLAY_HEX_NUMBER
    
    RET
BINARY_TO_HEX ENDP

; Procedure to display a number in AX as hexadecimal
DISPLAY_HEX_NUMBER PROC
    ; Handle special case of zero
    CMP AX, 0
    JNE START_CONVERSION
    MOV DL, '0'
    MOV AH, 02H
    INT 21H
    RET
    
START_CONVERSION:
    MOV CX, 0           ; Counter for hex digits
    MOV BX, 16          ; Base 16 for hex
    
HEX_CONVERT_LOOP:
    MOV DX, 0           ; Clear DX for division
    DIV BX              ; Divide by 16
    PUSH DX             ; Save remainder (hex digit)
    INC CX              ; Count digits
    CMP AX, 0
    JNE HEX_CONVERT_LOOP
    
    ; Display hex digits in reverse order
HEX_DISPLAY_LOOP:
    POP DX              ; Get hex digit
    CMP DL, 9
    JLE HEX_NUMERIC
    
    ; It's A-F
    ADD DL, 'A' - 10
    JMP HEX_DISPLAY_CHAR
    
HEX_NUMERIC:
    ADD DL, '0'         ; Convert 0-9 to ASCII
    
HEX_DISPLAY_CHAR:
    MOV AH, 02H         ; Display character
    INT 21H
    LOOP HEX_DISPLAY_LOOP
    
    RET
DISPLAY_HEX_NUMBER ENDP

END MAIN