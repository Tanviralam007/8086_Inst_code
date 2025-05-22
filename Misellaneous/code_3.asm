;Take a binary from the user and print the same digit back using stack

.MODEL SMALL
.STACK 100H

.DATA
    PROMPT      DB 'Enter binary digits (0 or 1), end with Enter: $' 
    NEWLINE     DB 0DH, 0AH, '$'
    MSG_OUTPUT  DB 'You entered: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Display prompt
    LEA DX, PROMPT
    MOV AH, 09H
    INT 21H

    ; Read binary digits and push to stack
    MOV CX, 0           ; Counter for number of digits
    
READ_LOOP:
    MOV AH, 01H         ; Read character
    INT 21H
    
    CMP AL, 0DH         ; Check if Enter key (carriage return)
    JE DISPLAY_OUTPUT   ; If Enter, go to output
    
    CMP AL, '0'         ; Check if character is '0'
    JE VALID_DIGIT
    CMP AL, '1'         ; Check if character is '1'
    JE VALID_DIGIT
    
    ; If not 0 or 1, ignore and continue reading
    JMP READ_LOOP

VALID_DIGIT:
    PUSH AX             ; Push the digit to stack
    INC CX              ; Increment digit counter
    JMP READ_LOOP       ; Continue reading

DISPLAY_OUTPUT:
    ; Print newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    
    ; Display output message
    LEA DX, MSG_OUTPUT
    MOV AH, 09H
    INT 21H

    ; Check if any digits were entered
    CMP CX, 0
    JE END_PROGRAM      ; If no digits, exit
    
    ; Pop digits from stack and display in reverse order to get original sequence
    ; We need to pop all digits and store them, then display in reverse
    MOV SI, 0           ; Index for temporary storage
    
POP_TO_TEMP:
    CMP CX, 0           ; Check if all digits processed
    JE DISPLAY_DIGITS   ; If yes, start displaying
    
    POP AX              ; Pop digit from stack
    MOV TEMP_STORAGE[SI], AL  ; Store in temporary array
    INC SI              ; Increment index
    DEC CX              ; Decrement counter
    JMP POP_TO_TEMP

DISPLAY_DIGITS:
    ; Display digits from temporary storage in reverse order (original input order)
    DEC SI              ; SI now points to last stored digit
    
DISPLAY_LOOP:
    CMP SI, 0
    JL END_PROGRAM      ; If SI < 0, we're done
    
    MOV DL, TEMP_STORAGE[SI]  ; Get digit from temporary storage
    MOV AH, 02H         ; Display character function
    INT 21H
    
    DEC SI              ; Move to previous digit
    JMP DISPLAY_LOOP

END_PROGRAM:
    ; Print final newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H

    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP

; Temporary storage for digits (max 100 characters)
TEMP_STORAGE DB 100 DUP(?)

END MAIN