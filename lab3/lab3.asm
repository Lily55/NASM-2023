%include "../lib.asm"

    section .data
        A dd 5
        B dd -6

    section .bss
        F resd 1
        OutBuf resb 10

    section .text
        global _start

_start:
    mov ax, [A]
    mov bx, [B]
    imul bx

    cmp ax, 0
    jle less
    mov ax, [A]
    mov bx, [B]
    sub ax, bx
    mov cx, ax
    mov ax, [A]
    add ax, bx
    cwd
    idiv cx
    jmp com
less:
    ; mov ax, [A]
    ; mov bx, [B]
    ; imul bx
    mov ebx, eax
    mov ax, -120
    cwd
    idiv bx

com:

    ; конвертируем произведение из целого в строку
    mov esi, OutBuf
    cwde
    call IntToStr64

    ; write
    mov edx, eax
    mov eax, 1        
    mov edi, 1        
    syscall     

    ;exit
    mov rax, 60
    xor rdi, rdi
    syscall
