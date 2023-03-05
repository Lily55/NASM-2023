    section .data
;val1 db 255
; chart dw 256
; lue3 dw -128
; v5 db 10h
;     db 100101B
; beta db 23,23h,0ch
; sdk db "Hello",10
; min dw -32767
; ar dd 12345678h
; valar times 5 db 8
;C dw 37
F1 dw 65535
F2 dd 65535
A dw 5,-5
; B dw 21
ExitMsg db "Press Enter to Exit",10
lenExit equ $-ExitMsg

    section .bss
InBuf resb 10
lenIn equ $-InBuf
X resd 1
; alu resw 10
; f1 resb 5

    section .text
    global _start

_start:
    ; mov rax,[A] ; загрузить число A в регистр EAX
    ; add rax,5; сложить EAX и 5, результат в EAX
    ; sub rax,[B] ; вычесть число B, результат в EAX
    ; mov [X],rax 

    mov ax, [A]

    mov rax, 1
    mov rdi, 1
    mov rsi, ExitMsg
    mov rdx, lenExit
    syscall
    
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, lenIn
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall