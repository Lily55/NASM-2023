%include "lib.asm"

    section .data
    ExitMsg db "",10
    lenExit equ $-ExitMsg
    INPUT_LEN db 32
    input db "qwerty dfgh vbnmfcser ah kljwert"

    section .bss
    LetterCount resb 32
    OutBuf resb 32
    ; input resb 32

    section .text
    global _start

_start:
    ; mov rdi, 0
    ; mov rsi, input
    ; mov rdx, 32
    ; syscall

    mov ebx, 0
    xor rdx, rdx ; letter counter
    xor rax, rax ; words counter
    mov rsi, input
    mov ecx, 33
    dec rsi
   

main_cycle:
    inc rsi
    inc rdx

    cmp byte[rsi], ' '
    je countW

    cmp byte[rsi], 0
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
