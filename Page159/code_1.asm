;Write a program that lets the user type some text, consisting of 
;words separated by blanks, ending with a carriage return, and displays the text in the same word order as entered, 
;but with the letters in each word reversed. 
;For example, "this is a test" becomes 
;"siht si a test"

solve with user input
.MODEL SMALL
.STACK 100H
.DATA
    PROMPT_MSG DB 'Enter text (words separated by spaces): $'
    OUTPUT_MSG DB 0DH, 0AH, 'Reversed letters in each word: $'
    INPUT_BUFFER DB 255 DUP(0)
    NEWLINE DB 0DH, 0AH, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, PROMPT_MSG
    MOV AH, 09H
    INT 21H
    
    ; Read input line
    CALL READ_LINE
    
    ; Display output message
    LEA DX, OUTPUT_MSG
    MOV AH, 09H
    INT 21H
    
    ; Process and display the text with reversed letters in each word
    CALL PROCESS_TEXT
    
    ; Display newline
    LEA DX, NEWLINE
    MOV AH, 09H
    INT 21H
    
    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; Procedure to read a line of text
READ_LINE PROC
    LEA SI, INPUT_BUFFER
    MOV CX, 0               ; Character counter
    
READ_LOOP:
    MOV AH, 01H             ; Read character with echo
    INT 21H
    
    CMP AL, 0DH             ; Check for carriage return
    JE END_READ
    
    MOV [SI], AL            ; Store character in buffer
    INC SI
    INC CX
    CMP CX, 254             ; Prevent buffer overflow
    JL READ_LOOP
    
END_READ:
    MOV BYTE PTR [SI], 0    ; Null terminate the string
    RET
READ_LINE ENDP

; Procedure to process text and reverse letters in each word
PROCESS_TEXT PROC
    LEA SI, INPUT_BUFFER    ; Source pointer
    
PROCESS_LOOP:
    MOV AL, [SI]            ; Get current character
    CMP AL, 0               ; Check for end of string
    JE END_PROCESS
    
    CMP AL, ' '             ; Check for space
    JE PRINT_SPACE
    
    ; Start of a word - push letters onto stack until space or end
    CALL REVERSE_WORD
    JMP PROCESS_LOOP
    
PRINT_SPACE:
    ; Print the space
    MOV DL, ' '
    MOV AH, 02H
    INT 21H
    INC SI                  ; Move to next character
    JMP PROCESS_LOOP
    
END_PROCESS:
    RET
PROCESS_TEXT ENDP

; Procedure to reverse a single word using stack
REVERSE_WORD PROC
    PUSH CX                 ; Save CX register
    MOV CX, 0               ; Counter for letters in word
    
    ; Push all letters of the word onto stack
PUSH_LETTERS:
    MOV AL, [SI]            ; Get current character
    CMP AL, 0               ; Check for end of string
    JE POP_AND_PRINT
    CMP AL, ' '             ; Check for space (end of word)
    JE POP_AND_PRINT
    
    PUSH AX                 ; Push letter onto stack (using AX to be safe)
    INC CX                  ; Count the letter
    INC SI                  ; Move to next character
    JMP PUSH_LETTERS
    
POP_AND_PRINT:
    ; Pop and print all letters (they come out in reverse order)
    CMP CX, 0               ; Check if there are letters to pop
    JE REVERSE_DONE
    
    POP AX                  ; Pop letter from stack
    MOV DL, AL              ; Move to DL for printing
    MOV AH, 02H             ; Display character function
    INT 21H                 ; Print the character
    DEC CX                  ; Decrement counter
    JMP POP_AND_PRINT
    
REVERSE_DONE:
    POP CX                  ; Restore CX register
    RET
REVERSE_WORD ENDP

END MAIN