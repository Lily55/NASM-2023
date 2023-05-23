%include "lib.asm"

section .data
ExitMsg db " ", 10
lenExit equ $-ExitMsg

A   dw  1, 2, 3, 4, -5          ; пришлось исправить тип на word из-за того, что IntToStr64 не хотела нормально преобразовывать числа и выдавала ошибку
    dw  6, -7, 8, 9, 10
    dw  11, 12, -13, 14, 15
    dw  16, 8, 18, 19, 20
    dw  -10, 15, 13, 11, 7      

section .bss
S resb 1
Output resb 50

section .text
global _start

_start:
    mov cx, 5
    mov esi, 8
    mov rax, 1     ; добавила, чтобы у нас в rax произведение не было равно нулю, изначально в rax нужно что-то положить

cycle:
    xor bx, bx
    mov bx, [A + esi]
    cmp bx, 0
    jl umnog
    jmp next

umnog:
    imul bx

next:
    add esi, 8
    loop cycle


    mov [A + 22], ax

    mov ecx, 5
    mov ebx, 0

cycle1:
    push rcx
    mov ecx, 5
cycle2:
    push rcx
    mov rax, [A + 2*ebx]


    mov esi, Output ; исправила rdi на esi
    cwde            ; исправила cbw на cwde
    call IntToStr64

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall

    pop rcx

    inc ebx
    loop cycle2

    mov rax, 1
    mov rdi, 1
    mov rsi, ExitMsg
    mov rdx, lenExit
    syscall

    pop rcx

    loop cycle1

    mov rax, 60
    xor rdi, rdi
    syscall 