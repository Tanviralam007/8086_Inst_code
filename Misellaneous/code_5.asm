;Take bin input from the user, and display the hex value of the bin input.
.MODEL SMALL
.STACK 100H

.DATA
    PROMPT      DB 'Enter binary digits (0 or 1): $'
    NEWLINE     DB 0DH, 0AH, '$'
    MSG_OUTPUT  DB 'Hexadecimal equivalent: $'
    BIN_INPUT   DB 400 DUP(?)   ; Storage for binary input
    HEX_OUTPUT  DB 100 DUP(?)   ; Storage for hex output

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

MAIN_LOOP:
    LEA DX, PROMPT
    MOV AH, 09H
    INT 21H

    ; Read binary input
    MOV SI, 0           ; Index for binary input storage
    
READ_BINARY:
    MOV AH, 01H         ; Read character
    INT 21H
    
    CMP AL, 0DH         ; Check if Enter key
    JE CONVERT_TO_HEX
    
    ; Validate binary digit
    CMP AL, '0'
    JE VALID_BIN
    CMP AL, '1'
    JE VALID_BIN
    JMP READ_BINARY     ; Ignore invalid characters
    
VALID_BIN:
    MOV BIN_INPUT[SI], AL
    INC SI
    JMP READ_BINARY

CONVERT_TO_HEX:
    ; Check if any binary digits were entered
    CMP SI, 0
    JE EXIT_PROGRAM
    
    ; Pad with leading zeros to make length multiple of 4
    MOV AX, SI          ; Number of binary digits
    MOV BL, 4
    DIV BL              ; AX / 4
    CMP AH, 0           ; Check remainder
    JE NO_PADDING
    
    ; Add padding zeros
    MOV CL, 4
    SUB CL, AH          ; Number of zeros to add
    MOV DI, SI          ; Current length
    ADD SI, CX          ; New length
    
    ; Shift existing digits to right
SHIFT_RIGHT:
    MOV AL, BIN_INPUT[DI-1]
    MOV BIN_INPUT[DI+CX-1], AL
    DEC DI
    CMP DI, 0
    JNE SHIFT_RIGHT
    
    ; Add leading zeros
    MOV DI, 0
ADD_ZEROS:
    MOV BIN_INPUT[DI], '0'
    INC DI
    LOOP ADD_ZEROS

NO_PADDING:
    ; Convert groups of 4 binary digits to hex
    MOV CX, SI          ; Total binary digits
    SHR CX, 2           ; Divide by 4 (number of hex digits)
    MOV SI, 0           ; Index for binary input
    MOV DI, 0           ; Index for hex output
    
CONVERT_LOOP:
    ; Process 4 binary digits
    MOV AL, 0           ; Initialize hex value
    MOV BL, 8           ; Bit position multiplier (8, 4, 2, 1)
    
    ; Process 4 bits
    MOV DH, 4           ; Counter for 4 bits
PROCESS_4_BITS:
    MOV AH, BIN_INPUT[SI]
    SUB AH, '0'         ; Convert ASCII to numeric
    
    ; If bit is 1, add its value to AL
    CMP AH, 1
    JNE SKIP_BIT
    ADD AL, BL          ; Add bit value
    
SKIP_BIT:
    SHR BL, 1           ; Next bit position (8->4->2->1)
    INC SI              ; Next binary digit
    DEC DH
    JNZ PROCESS_4_BITS
    
    ; Convert numeric value (0-15) to hex ASCII
    CMP AL, 9
    JBE NUMERIC_HEX
    
    ; A-F case
    SUB AL, 10
    ADD AL, 'A'
    JMP STORE_HEX
    
NUMERIC_HEX:
    ; 0-9 case
    ADD AL, '0'
    
STORE_HEX:
    MOV HEX_OUTPUT[DI], AL
    INC DI
    LOOP CONVERT_LOOP

    ; Display result
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    
    LEA DX, MSG_OUTPUT
    MOV AH, 09H
    INT 21H
    
    ; Display hex output
    MOV CX, DI          ; Number of hex digits
    MOV SI, 0
    
DISPLAY_HEX:
    MOV DL, HEX_OUTPUT[SI]
    MOV AH, 02H
    INT 21H
    INC SI
    LOOP DISPLAY_HEX
    
    ; Print newlines
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    
    ; Clear input buffer for next input
    MOV CX, 400
    MOV SI, 0
    MOV AL, 0
CLEAR_INPUT:
    MOV BIN_INPUT[SI], AL
    INC SI
    LOOP CLEAR_INPUT
    
    ; Clear output buffer
    MOV CX, 100
    MOV SI, 0
    MOV AL, 0
CLEAR_OUTPUT:
    MOV HEX_OUTPUT[SI], AL
    INC SI
    LOOP CLEAR_OUTPUT
    
    JMP MAIN_LOOP       ; Continue for next input

EXIT_PROGRAM:
    MOV AH, 4CH
    INT 21H

MAIN ENDP

END MAIN