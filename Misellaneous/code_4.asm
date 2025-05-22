;Take hex input from user, display the binary value of the hex input.
.MODEL SMALL
.STACK 100H

.DATA
    PROMPT      DB 'Enter hexadecimal digits (0-9, A-F): $'
    NEWLINE     DB 0DH, 0AH, '$'
    MSG_OUTPUT  DB 'Binary equivalent: $'
    HEX_INPUT   DB 100 DUP(?)   ; Storage for hex input
    BIN_OUTPUT  DB 400 DUP(?)   ; Storage for binary output (4 bits per hex digit)

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

MAIN_LOOP:
    LEA DX, PROMPT
    MOV AH, 09H
    INT 21H

    ; Read hex input
    MOV SI, 0           ; Index for hex input storage
    
READ_HEX:
    MOV AH, 01H         ; Read character
    INT 21H
    
    CMP AL, 0DH         ; Check if Enter key
    JE CONVERT_TO_BINARY
    
    ; Validate hex digit
    CALL VALIDATE_HEX
    CMP BL, 0FFH        ; Check if invalid
    JE READ_HEX         ; If invalid, ignore and continue
    
    ; Store valid hex digit
    MOV HEX_INPUT[SI], AL
    INC SI
    JMP READ_HEX

CONVERT_TO_BINARY:
    ; Check if any hex digits were entered
    CMP SI, 0
    JE EXIT_PROGRAM
    
    MOV CX, SI          ; Number of hex digits
    MOV SI, 0           ; Reset index for hex input
    MOV DI, 0           ; Index for binary output
    
CONVERT_LOOP:
    MOV AL, HEX_INPUT[SI]   ; Get hex digit
    CALL HEX_TO_BIN         ; Convert to 4-bit binary
    
    ; Store 4 binary digits
    MOV BX, 4
STORE_BITS:
    MOV DL, AH
    AND DL, 80H         ; Get MSB
    SHR DL, 7           ; Move to LSB position
    ADD DL, '0'         ; Convert to ASCII
    MOV BIN_OUTPUT[DI], DL
    INC DI
    SHL AH, 1           ; Shift left for next bit
    DEC BX
    JNZ STORE_BITS
    
    INC SI              ; Next hex digit
    LOOP CONVERT_LOOP

    ; Display result
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    
    LEA DX, MSG_OUTPUT
    MOV AH, 09H
    INT 21H
    
    ; Display binary output
    MOV CX, DI          ; Number of binary digits
    MOV SI, 0
    
DISPLAY_BINARY:
    MOV DL, BIN_OUTPUT[SI]
    MOV AH, 02H
    INT 21H
    INC SI
    LOOP DISPLAY_BINARY
    
    ; Print newlines
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    
    ; Clear input buffer for next input
    MOV CX, 100
    MOV SI, 0
    MOV AL, 0
CLEAR_INPUT:
    MOV HEX_INPUT[SI], AL
    INC SI
    LOOP CLEAR_INPUT
    
    JMP MAIN_LOOP       ; Continue for next input

EXIT_PROGRAM:
    MOV AH, 4CH
    INT 21H

MAIN ENDP

; Procedure to validate hex digit
; Input: AL = character to validate
; Output: BL = 0FFH if invalid, otherwise valid
VALIDATE_HEX PROC
    ; Check if 0-9
    CMP AL, '0'
    JB INVALID_HEX
    CMP AL, '9'
    JBE VALID_HEX
    
    ; Check if A-F
    CMP AL, 'A'
    JB INVALID_HEX
    CMP AL, 'F'
    JBE VALID_HEX
    
    ; Check if a-f (convert to uppercase)
    CMP AL, 'a'
    JB INVALID_HEX
    CMP AL, 'f'
    JA INVALID_HEX
    
    ; Convert lowercase to uppercase
    SUB AL, 20H
    
VALID_HEX:
    MOV BL, 0           ; Valid
    RET
    
INVALID_HEX:
    MOV BL, 0FFH        ; Invalid
    RET
VALIDATE_HEX ENDP

; Procedure to convert hex digit to 4-bit binary
; Input: AL = hex digit (ASCII)
; Output: AH = 4-bit binary value
HEX_TO_BIN PROC
    CMP AL, '9'
    JBE NUMERIC_HEX
    
    ; A-F case
    SUB AL, 'A'
    ADD AL, 10
    JMP STORE_BINARY
    
NUMERIC_HEX:
    ; 0-9 case
    SUB AL, '0'
    
STORE_BINARY:
    ; AL now contains the numeric value (0-15)
    ; Convert to 4-bit pattern in AH
    MOV AH, AL
    SHL AH, 4           ; Move to upper 4 bits for easier bit extraction
    RET
HEX_TO_BIN ENDP
END MAIN