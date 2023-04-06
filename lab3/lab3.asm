%include "../lib.asm"

    section .data
    ExitMsg db "Press Enter to Exit",10
    lenExit equ $-ExitMsg
    EnterAMsg db "Enter the A which isn't 0: "
    lenEnterA equ $-EnterAMsg
    EnterBMsg db "Enter the B which isn't 0: "
    lenEnterB equ $-EnterBMsg
    ResMsg db "The result is: "
    lenRes equ $-ResMsg
    WrongAMsg db "A is 0!", 10
    lenWrongA equ $-WrongAMsg
    WrongBMsg db "B is 0!", 10
    lenWrongB equ $-WrongBMsg

    section .bss
        A resd 1
        B resd 1
        OutBuf resb 10
        InBuf   resb    10
        lenIn   equ     $-InBuf 

    section .text
        global _start

_start:

rightA:
    ; write EnterAMsg
    mov     rax, 1        
    mov     rdi, 1        
    mov     rsi, EnterAMsg  
    mov     rdx, lenEnterA  
    syscall  

    ; read A
    mov     rax, 0        
    mov     rdi, 0        
    mov     rsi, InBuf    
    mov     rdx, lenIn    
    syscall  

    mov esi, InBuf
    call StrToInt64
    cmp ebx, 0

    ; проверка неравенства А нулю
    cmp eax, 0
    je rightA
    mov [A], eax

rightB:    
    ; write EnterBMsg
    mov     rax, 1        
    mov     rdi, 1        
    mov     rsi, EnterBMsg  
    mov     rdx, lenEnterB  
    syscall 

    ; read B
    mov     rax, 0      
    mov     rdi, 0        
    mov     rsi, InBuf    
    mov     rdx, lenIn    
    syscall  

    mov esi, InBuf
    call StrToInt64
    cmp ebx, 0

    ; проверка неравенства B нулю
    cmp eax, 0
    je rightB
    mov [B], eax

    ; перемножение чисел для условия
    mov ax, [A]
    mov bx, [B]
    imul bx

    ; начало сравнения
    cmp ax, 0   ; сравнение данных в ах с 0
    jl less     ; если число в ах < 0, переходим на метку less 
    mov ax, [A] ; если число в ах > 0, продолжаем вычисления в этом блоке
    mov bx, [B]
    sub ax, bx
    mov cx, ax
    mov ax, [A]
    add ax, bx
    cwd
    idiv cx
    jmp com     ; по завершению вычислений переходим на метку com

less:               ; при переходе по метке less делаем другие вычисления
    mov ebx, eax
    mov ax, -120
    cwd
    idiv bx

com:                ; при переходе не метку com выводим результат

    mov ebx, eax ; переносим данные из EAX в EBX

    ; write ResMsg
    mov     rax, 1        
    mov     rdi, 1        
    mov     rsi, ResMsg  
    mov     rdx, lenRes  
    syscall 

    mov eax, ebx ; переносим число обратно в EAX

    ; конвертируем частное из целого в строку
    mov esi, OutBuf
    cwde
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

    ; read Enter
    mov     rax, 0        
    mov     rdi, 0        
    mov     rsi, InBuf    
    mov     rdx, lenIn    
    syscall  

    ;exit
    mov rax, 60
    xor rdi, rdi
    syscall
