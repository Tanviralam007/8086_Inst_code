; Assembly program to read a hex digit, convert it to binary,
; count the number of 1s and 0s, and check if the number is even or odd.

.MODEL SMALL
.STACK 100H
.DATA
    PROMPT DB 'ENTER HEX DIGIT (0-9, A-F): $'
    BINARY_MSG DB 0DH, 0AH, 'BINARY: $'
    ONES_MSG DB 0DH, 0AH, 'NUMBER OF 1s: $'
    ZEROS_MSG DB 0DH, 0AH, 'NUMBER OF 0s: $'
    EVEN_MSG DB 0DH, 0AH, 'EVEN NUMBER$'
    ODD_MSG DB 0DH, 0AH, 'ODD NUMBER$'
    NEWLINE DB 0DH, 0AH, '$'
    HEX_VALUE DB ?
    ONES_COUNT DB 0
    ZEROS_COUNT DB 0
    
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; Display PROMPT
    LEA DX, PROMPT
    MOV AH, 09H
    INT 21H
    
    ; Read hex character
    MOV AH, 01H
    INT 21H
    MOV HEX_VALUE, AL
    
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
    LEA DX, BINARY_MSG
    MOV AH, 09H
    INT 21H
    
    ; Initialize counters
    MOV ONES_COUNT, 0
    MOV ZEROS_COUNT, 0
    
    ; Test bit 3 (MSB)
    TEST BL, 08H        ; Test bit 3 (binary 1000)
    JZ BIT3_ZERO
    MOV DL, '1'
    INC ONES_COUNT
    JMP PRINT_BIT3
BIT3_ZERO:
    MOV DL, '0'
    INC ZEROS_COUNT
PRINT_BIT3:
    MOV AH, 02H
    INT 21H
    
    ; Test bit 2
    TEST BL, 04H        ; Test bit 2 (binary 0100)
    JZ BIT2_ZERO
    MOV DL, '1'
    INC ONES_COUNT
    JMP PRINT_BIT2
BIT2_ZERO:
    MOV DL, '0'
    INC ZEROS_COUNT
PRINT_BIT2:
    MOV AH, 02H
    INT 21H
    
    ; Test bit 1
    TEST BL, 02H        ; Test bit 1 (binary 0010)
    JZ BIT1_ZERO
    MOV DL, '1'
    INC ONES_COUNT
    JMP PRINT_BIT1
BIT1_ZERO:
    MOV DL, '0'
    INC ZEROS_COUNT
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
    INC ZEROS_COUNT
PRINT_BIT0:
    MOV AH, 02H
    INT 21H
    
    ; Display count of 1s
    LEA DX, ONES_MSG
    MOV AH, 09H
    INT 21H
    
    MOV AL, ones_count
    ADD AL, '0'         ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    
    ; Display count of 0s
    LEA DX, ZEROS_MSG
    MOV AH, 09H
    INT 21H
    
    MOV AL, ZEROS_COUNT
    ADD AL, '0'         ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    
    ; Check if number is even or odd using TEST
    TEST BL, 01H        ; Test the LSB (bit 0)
    JNZ NUMBER_IS_ODD   ; If bit 0 is 1, number is odd
    
    ; Number is even
    LEA DX, EVEN_MSG
    MOV AH, 09H
    INT 21H
    JMP PRINT_FINAL_NEWLINE
    
NUMBER_IS_ODD:
    ; Number is odd
    LEA DX, ODD_MSG
    MOV AH, 09H
    INT 21H
    
PRINT_FINAL_NEWLINE:
    ; Print NEWLINE
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    
EXIT_PROGRAM:
    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN