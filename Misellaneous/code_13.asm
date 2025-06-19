; Assembly program to read two hex digits (single byte), convert to binary,
; count the number of 1s and 0s, and check if the number is even or odd.

.MODEL SMALL
.STACK 100H
.DATA
    PROMPT DB 'ENTER TWO HEX DIGITS (00-FF): $'
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
; Subroutine to convert hex character to numeric value
CONVERT_HEX_CHAR PROC
    CMP AL, '9'
    JBE DIGIT           ; If AL <= '9', it's a digit
    CMP AL, 'F'
    JBE UPPER_LETTER    ; If AL <= 'F', it's uppercase letter
    CMP AL, 'f'
    JBE LOWER_LETTER    ; If AL <= 'f', it's lowercase letter
    JMP EXIT_PROGRAM    ; Invalid input
    
DIGIT:
    SUB AL, '0'         ; Convert '0'-'9' to 0-9
    JMP CONVERT_DONE
    
UPPER_LETTER:
    SUB AL, 'A'         ; Convert 'A'-'F' to 0-5
    ADD AL, 10          ; Make it 10-15
    JMP CONVERT_DONE
    
LOWER_LETTER:
    SUB AL, 'a'         ; Convert 'a'-'f' to 0-5
    ADD AL, 10          ; Make it 10-15
    
CONVERT_DONE:
    RET
CONVERT_HEX_CHAR ENDP

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; Display PROMPT
    LEA DX, PROMPT
    MOV AH, 09H
    INT 21H
    
    ; Read first hex character
    MOV AH, 01H
    INT 21H
    CALL CONVERT_HEX_CHAR
    MOV BH, AL          ; Store first digit in BH
    
    ; Read second hex character
    MOV AH, 01H
    INT 21H
    CALL CONVERT_HEX_CHAR
    MOV BL, AL          ; Store second digit in BL
    
    ; Combine: first digit * 16 + second digit
    MOV AL, BH          ; Get first digit
    MOV AH, 0           ; Clear high byte
    MOV CL, 4           ; Shift left by 4 positions
    SHL AL, CL          ; Multiply by 16
    ADD AL, BL          ; Add second digit
    MOV BL, AL          ; Store result back in BL
    
    MOV HEX_VALUE, BL   ; Store complete byte value
    
    ; Display binary message
    LEA DX, BINARY_MSG
    MOV AH, 09H
    INT 21H
    
    ; Initialize counters
    MOV ONES_COUNT, 0
    MOV ZEROS_COUNT, 0
    
    ; Convert 8-bit value to binary and count 1s and 0s
    MOV CX, 8           ; Process 8 bits
    MOV HEX_VALUE, BL   ; Store original value in memory
    
BIT_LOOP:
    ; Test the MSB and shift
    SHL BL, 1           ; Shift left, MSB goes to carry
    JC BIT_IS_ONE       ; If carry set, bit was 1
    
    ; Bit is 0
    MOV DL, '0'
    INC ZEROS_COUNT
    JMP PRINT_BIT
    
BIT_IS_ONE:
    ; Bit is 1
    MOV DL, '1'
    INC ONES_COUNT
    
PRINT_BIT:
    PUSH AX
    MOV AH, 02H
    INT 21H
    POP AX
    
    LOOP BIT_LOOP
    
    ; Display count of 1s
    LEA DX, ONES_MSG
    MOV AH, 09H
    INT 21H
    
    MOV AL, ONES_COUNT
    CMP AL, 9           ; Check if count > 9
    JBE SINGLE_DIGIT_ONES
    
    ; Handle two-digit count for 1s
    MOV AH, 0
    MOV BL, 10
    DIV BL              ; AL = quotient, AH = remainder
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    MOV AL, AH          ; Get remainder
    
SINGLE_DIGIT_ONES:
    ADD AL, '0'         ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    
    ; Display count of 0s
    LEA DX, ZEROS_MSG
    MOV AH, 09H
    INT 21H
    
    MOV AL, ZEROS_COUNT
    CMP AL, 9           ; Check if count > 9
    JBE SINGLE_DIGIT_ZEROS
    
    ; Handle two-digit count for 0s
    MOV AH, 0
    MOV BL, 10
    DIV BL              ; AL = quotient, AH = remainder
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    MOV AL, AH          ; Get remainder
    
SINGLE_DIGIT_ZEROS:
    ADD AL, '0'         ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    
    ; Check if number is even or odd using TEST
    MOV AL, HEX_VALUE   ; Use stored original value
    TEST AL, 01H        ; Test the LSB (bit 0)
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
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN

; sample output: 
; ENTER TWO HEX DIGITS (00-FF): 1F
; BINARY: 00011111
; NUMBER OF 1s: 5
; NUMBER OF 0s: 3
; ODD NUMBER