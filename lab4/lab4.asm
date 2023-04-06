%include "lib.asm"

section .data
MAS dw 9, 2, 2, 5, 8, 3, 5, -1
ExitMsg db "",10
lenExit equ $-ExitMsg

section .bss
NewUnicMAS resw 8
NewMAS resw 8
OutBuf resb 10

section .text
global _start

_start:

    mov ebx, 0
    mov ecx, 8
    mov rsi, 0
    mov rdi, 0

cycle1:         ; цикл прохода по массиву MAS в поиске уникальных элементов
    push rcx
    mov dx, 0
    mov ecx, 8
    mov ax, [ebx*2 + MAS]
    push rbx
    mov ebx, 0
cycle2:         ; цикл в котором происходит сравнение
    inc ebx     ; текущего элемента цикла1 со всеми
    cmp ax, [ebx*2 + MAS] ; элементами массива MAS для выявления уникального элемента
    je plus
    jmp next1
plus:
    inc dx
next1:
    loop cycle2

    cmp dx, 2
    jl dobU
    jge dobR
    jmp next2
dobU:
    mov [rsi*2 + NewUnicMAS], ax
    inc rsi
    jmp next2
dobR:
    mov [rdi*2 + NewMAS], ax
    inc rdi
next2:
    pop rbx
    inc ebx
    pop rcx
    loop cycle1

    mov ebx, 0
    mov ecx, 8
cycle3:
    mov ax, [ebx*2 + NewUnicMAS]
    inc ebx
    push rcx

    ; конвертируем частное из целого в строку
    mov esi, OutBuf
    cwde
    call IntToStr64

    ; write
    mov edx, eax
    mov eax, 1        
    mov edi, 1        
    syscall 

    pop rcx
    loop cycle3

;end:
    ; write ExitMsg
    mov     rax, 1        
    mov     rdi, 1        
    mov     rsi, ExitMsg  
    mov     rdx, lenExit  
    syscall  

    mov ebx, 0
    mov ecx, 8
cycle4:
    mov ax, [ebx*2 + NewMAS]
    inc ebx
    push rcx

    ; конвертируем частное из целого в строку
    mov esi, OutBuf
    cwde
    call IntToStr64

    ; write
    mov edx, eax
    mov eax, 1        
    mov edi, 1        
    syscall 

    pop rcx
    loop cycle4  

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