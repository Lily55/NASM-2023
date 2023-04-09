%include "lib.asm"

; %define INPUT_LEN 33

    section .data
    EnterMsg db "Enter the string 32 letters long or smaller: ", 10
    lenEnter equ $-EnterMsg
    WordsNumber db "Words number is: "
    lenWordsNumber equ $-WordsNumber
    INPUT_LEN db 33
    LettersNumber db "Letters numbers are: "
    lenLettersNumber equ $-LettersNumber
    ExitMsg db "",10
    lenExit equ $-ExitMsg
    ; input db "qwerty dfgh vbnmfcser ah kljwert"

    section .bss
    LetterCount resb 32
    OutBuf resb 32
    input resb 33

    section .text
    global _start

_start:

    ; write EnterMsg
    mov     rax, 1        
    mov     rdi, 1        
    mov     rsi, EnterMsg  
    mov     rdx, lenEnter  
    syscall 

    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, INPUT_LEN
    syscall

    mov rcx, rax
    mov ebx, 0
    xor rdx, rdx ; letter counter
    xor rax, rax ; words counter
    dec rsi
   

main_cycle:
    inc rsi
    inc rdx

    cmp byte[rsi], ' '
    je countW

    cmp byte[rsi], 10
    je countW
    jmp next

countW:
    dec rdx
    inc rax
    mov [ebx + LetterCount], rdx
    xor rdx, rdx
    inc ebx
    jmp next

next:
    loop main_cycle

    push rax

    ; выводим сообщение о количестве слов
    mov rax, 1
    mov rdi, 1
    mov rsi, WordsNumber
    mov rdx, lenWordsNumber
    syscall

    pop rax
    push rax

    ; конвертируем частное из целого в строку
    mov esi, OutBuf
    cwd
    call IntToStr64

    ; write
    mov edx, eax
    mov eax, 1        
    mov edi, 1        
    syscall 

    ; write ExitMsg
    mov     rax, 1        
    mov     rdi, 1        
    mov     rsi, ExitMsg  
    mov     rdx, lenExit  
    syscall

    pop rax
    push rax

    ; выводим сообщение о количестве букв в словах
    mov rax, 1
    mov rdi, 1
    mov rsi, LettersNumber
    mov rdx, lenLettersNumber
    syscall

    pop rax
    push rax

    mov ebx, 0
    mov ecx, eax
OutputCycle:
    mov eax, [ebx + LetterCount]
    inc ebx
    push rcx

    ; конвертируем частное из целого в строку
    mov esi, OutBuf
    cbw
    call IntToStr64

    ; write
    mov edx, eax
    mov eax, 1        
    mov edi, 1        
    syscall 

    pop rcx
    loop OutputCycle  
  

    ; write ExitMsg
    mov     rax, 1        
    mov     rdi, 1        
    mov     rsi, ExitMsg  
    mov     rdx, lenExit  
    syscall  

    ;exit
    mov rax, 60
    xor rdi, rdi
    syscall
