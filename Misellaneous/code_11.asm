;Program that takes hex input, converts to binary, and counts 1s and 0s
;Sample execution:
;Enter hex digit (0-9, A-F): A
;BINARY: 1010
;NUMBER OF ONES: 2
;NUMBER OF ZEROS: 2

.MODEL SMALL
.STACK 100H
.DATA
    prompt DB 'Enter hex digit (0-9, A-F): $'
    binary_msg DB 0DH, 0AH, 'Binary: $'
    ones_msg DB 0DH, 0AH, 'Number of 1s: $'
    zeros_msg DB 0DH, 0AH, 'Number of 0s: $'
    newline DB 0DH, 0AH, '$'
    hex_value DB ?
    ones_count DB 0
    zeros_count DB 0
    
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; Display prompt
    LEA DX, prompt
    MOV AH, 09H
    INT 21H
    
    ; Read hex character
    MOV AH, 01H
    INT 21H
    MOV hex_value, AL
    
    ; Convert hex character to numeric value
    CMP AL, '9'
    JBE DIGIT           ; If <= '9', it's a digit
    CMP AL, 'F'
    JBE UPPER_LETTER    ; If <= 'F', it's uppercase letter
    CMP AL, 'f'
    JBE LOWER_LETTER    ; If <= 'f', it's lowercase letter
    JMP EXIT_PROGRAM    ; Invalid input
    
DIGIT:
    SUB AL, '0'         ; Convert '0'-'9' to 0-9
    JMP CONVERT_TO_BINARY
    
UPPER_LETTER:
    SUB AL, 'A'         ; Convert 'A'-'F' to 0-5
    ADD AL, 10          ; Make it 10-15
    JMP CONVERT_TO_BINARY
    
LOWER_LETTER:
    SUB AL, 'a'         ; Convert 'a'-'f' to 0-5
    ADD AL, 10          ; Make it 10-15
    
CONVERT_TO_BINARY:
    MOV BL, AL          ; Store hex value in BL
    
    ; Display binary message
    LEA DX, binary_msg
    MOV AH, 09H
    INT 21H
    
    ; Initialize counters
    MOV ones_count, 0
    MOV zeros_count, 0
    
    ; Test bit 3 (MSB)
    TEST BL, 08H        ; Test bit 3 (binary 1000)
    JZ BIT3_ZERO
    MOV DL, '1'
    INC ones_count
    JMP PRINT_BIT3
BIT3_ZERO:
    MOV DL, '0'
    INC zeros_count
PRINT_BIT3:
    MOV AH, 02H
    INT 21H
    
    ; Test bit 2
    TEST BL, 04H        ; Test bit 2 (binary 0100)
    JZ BIT2_ZERO
    MOV DL, '1'
    INC ones_count
    JMP PRINT_BIT2
BIT2_ZERO:
    MOV DL, '0'
    INC zeros_count
PRINT_BIT2:
    MOV AH, 02H
    INT 21H
    
    ; Test bit 1
    TEST BL, 02H        ; Test bit 1 (binary 0010)
    JZ BIT1_ZERO
    MOV DL, '1'
    INC ones_count
    JMP PRINT_BIT1
BIT1_ZERO:
    MOV DL, '0'
    INC zeros_count
PRINT_BIT1:
    MOV AH, 02H
    INT 21H
    
    ; Test bit 0 (LSB)
    TEST BL, 01H        ; Test bit 0 (binary 0001)
    JZ BIT0_ZERO
    MOV DL, '1'
    INC ones_count
    JMP PRINT_BIT0
BIT0_ZERO:
    MOV DL, '0'
    INC zeros_count
PRINT_BIT0:
    MOV AH, 02H
    INT 21H
    
    ; Display count of 1s
    LEA DX, ones_msg
    MOV AH, 09H
    INT 21H
    
    MOV AL, ones_count
    ADD AL, '0'         ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    
    ; Display count of 0s
    LEA DX, zeros_msg
    MOV AH, 09H
    INT 21H
    
    MOV AL, zeros_count
    ADD AL, '0'         ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    
    ; Print newline
    LEA DX, newline
    MOV AH, 09H
    INT 21H
    
EXIT_PROGRAM:
    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN