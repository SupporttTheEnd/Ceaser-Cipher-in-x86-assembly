; UMBC - CMSC 313 - Fall 2023 - Proj3
; Author: Andrew Tang
; ID: AI94171
; Date: 11/27/2023
; Description: This is a program that takes in a shift value and applies that shift
; as a caesar cipher to use inputed text. It has two checks, one to make sure that the shift
; value is between -25 and 25 inclusive as well as the entered string is more than 8 chars including the 
; end of string newline character. More specifically, it works by altering the inputed shift value string
; into a integer using the "convert" function. Then it apples such converted integer
; into the caesar cipher, which increments each character with wrapping around the alphabet for 
; upper and lower case. It only does the shift on alphabetical characters. 

; this is here to specify the stack to disable a stack warning
section .note.GNU-stack noalloc noexec nowrite progbits 
section .data
        ; define the messages to be outputed and store their respective lengths
        msg1:   db "Enter a shift value between -25 and 25 (included)", 10  ; output message along with a new line
        len1:   equ $-msg1
        msg2:   db "Enter a string greater than 8 characters", 10  ; output message along with a new line
        len2:   equ $-msg2
        msg3:   db "Current message: "
        len3:   equ $-msg3
        msg4:   db "Edited message: "
        len4:   equ $-msg4
section .bss
        buff:   resb 1000 ; Reserve space for the input string
        shift:  resb 8    ; Reserve space for the input shift value
section .text
        global main

main:
prompt1:
        ; print "Enter a shift value between -25 and 25 (included)"
        mov rax, 1          ; call to write()
        mov rdi, 1          ; write to stdout
        mov rsi, msg1       ; load pointer to data buffer
        mov rdx, len1        ; load value of buffer size
        syscall

        ; Read shift value
        mov rax, 0          ; call to read()
        mov rdi, 0          ; read from stdin
        mov rsi, shift      ; load pointer to data buffer
        mov rdx, 8          ; load value of buffer size
        syscall
        
        ; convert user string to integer
        call convert
        mov r8, rax
        
        ; compare user input value with 25; this is an abs value because I remove the - sign
        cmp r8, 25
        jg prompt1
        
        ; after apply the negative sign if needed
        movzx rcx, byte [shift] ; load the next byte
        cmp rcx, '-' ; check for minus 
        jne prompt2
        neg r8 
prompt2:
        ; print "Enter a string greater than 8 characters"
        mov rax, 1          ; call to write()
        mov rdi, 1          ; write to stdout
        mov rsi, msg2       ; load pointer to data buffer
        mov rdx, len2       ; load value of buffer size
        syscall

        ; Read string
        mov rax, 0          ; call to read()
        mov rdi, 0          ; read from stdin
        mov rsi, buff       ; load pointer to data buffer
        mov rdx, 1000       ; load value of buffer size
        syscall
        
        ; validate the string length
        cmp rax, 8
        jle prompt2
        ; store the length
        mov r9, rax

        ; print "Current message:"
        mov rax, 1          ; call to write()
        mov rdi, 1          ; write to stdout
        mov rsi, msg3       ; load pointer to data buffer
        mov rdx, len3       ; load value of buffer size
        syscall

        ; print the unedited buff
        mov rax, 1          ; call to write()
        mov rdi, 1          ; write to stdout
        mov rsi, buff       ; load pointer to data buffer
        mov rdx, r9
        syscall
        
        ; apply the caesar cipher
        mov rdi, r8          ; shift amount
        mov rsi, buff        ; pointer to the entered string
        call caesar_cipher

        ; print "Edited message:"
        mov rax, 1          ; call to write()
        mov rdi, 1          ; write to stdout
        mov rsi, msg4       ; load pointer to data buffer
        mov rdx, len4       ; load value of buffer size
        syscall
        
        ; print the edited buffer
        mov rax, 1          ; call to write()
        mov rdi, 1          ; write to stdout
        mov rsi, buff       ; load pointer to data buffer
        mov rdx, r9
        syscall

        ; exit the program
        mov rax, 60         ; call to exit
        xor rdi, rdi        ; return 0
        syscall

convert:
        xor rax, rax ; clear rax
loop:
        ; loop that translates a string to a integer
        movzx rcx, byte [rsi] ; load the next character
        cmp rcx, 10 ; check for new line character
        je done ; exit the loop if found

        cmp rcx, '-' ; check for minus sign
        je after ; skip iteration if found

        sub rcx, '0' ; convert the byte to a digit
        imul rax, rax, 10 ; multiply by 10

        add rax, rcx ; update the result
after:
        inc rsi ; increment the pointer
        
        jmp loop ; repeat the loop
done:
        ret ; return from the subroutine

caesar_cipher:
        movzx rax, byte [rsi] ; load the next character

        cmp rax, 0 ; check for the end of the string
        je  end_cipher_loop ; exit the loop if found

        cmp rax, 10  ; check for newline character
        je  end_cipher_loop ; exit the loop if found

        ; the following makes sure to only apply the shift to alphabetical characters
        cmp rax, 'A' ; check the character is below A in ASCII
        jl  after_shift ; if so skip
        cmp rax, 'z'; check the character is above z in ASCII
        jg  after_shift ; if so skip

        ; also skip the stuff in between
        cmp rax, 91
        je  after_shift
        cmp rax, 92
        je  after_shift
        cmp rax, 93
        je  after_shift
        cmp rax, 94
        je  after_shift
        cmp rax, 95
        je  after_shift
        cmp rax, 96
        je  after_shift

        cmp rax, 'a' ; check if the character is upper case
        jl  uppercase_shift ; if so go to the upper case section

lowercase_shift:
        ; need to clear this for division
        mov rdx, 0
        ; apply the shift to lowercase letters also using "mod" to resolve wrapping
        sub rax, 'a'
        add rax, rdi
        add rax, 26
        mov rbx, 26
        idiv rbx ; divide by 26, result in rax, remainder in rdx
        mov rax, rdx
        add rax, 'a'
        jmp after_shift

uppercase_shift:
        ; need to clear this for division
        mov rdx, 0
        ; Apply the shift to uppercase letters also using "mod" to resolve wrapping
        sub rax, 'A'
        add rax, rdi
        add rax, 26
        mov rbx, 26
        idiv rbx ; divide by 26, result in rax, remainder in rdx
        mov rax, rdx
        add rax, 'A'
        jmp after_shift

after_shift:
        mov [rsi], al ; store the result back in the string
        inc rsi ; Move to the next character 
        jmp caesar_cipher ; continue the loop

end_cipher_loop:
        ret ; return from the subroutine
