%include "../lib.asm"

    section .data
ExitMsg db "Press Enter to Exit",10
lenExit equ $-ExitMsg
EnterAMsg db "Enter the A: "
lenEnterA equ $-EnterAMsg
EnterBMsg db "Enter the B which isn't 5: "
lenEnterB equ $-EnterBMsg
EnterXMsg db "Enter the X: "
lenEnterX equ $-EnterXMsg
ResMsg db "The result is: "
lenRes equ $-ResMsg

    section .bss
a resd 1
b resd 1
d resd 1
x resd 1
OutBuf resb 10
InBuf   resb    10
lenIn   equ     $-InBuf 

    section .text
    global _start
_start:
    ; ; write EnterAMsg
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

    mov [a], eax

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

    mov [b], eax

    ; write EnterXMsg
    mov     rax, 1        
    mov     rdi, 1        
    mov     rsi, EnterXMsg  
    mov     rdx, lenEnterX  
    syscall 

    ; read X
    mov     rax, 0      
    mov     rdi, 0        
    mov     rsi, InBuf    
    mov     rdx, lenIn    
    syscall  

    mov esi, InBuf
    call StrToInt64
    cmp ebx, 0

    mov [x], eax


    ;знаменатель
    mov ebx, [b] ; EBX:= b
    mov edx, 5 ; EDX := 5
    sub ebx, 5 ; EBX - 5
    mov eax, ebx
    imul edx ; EBX * EDX
    mov ecx, eax ; b:= EAX (произведение и частное всегда в EAX)
    
    ;числитель
    mov eax, [a] ; AX:= a
    mov ebx, 3 ; BX:= 3
    imul ebx ; AX * BX, резульат в EAX
    mov ebx, [x] ; EBX:= x
    imul ebx ; EAX * EBX, резульат в EDX:EAX

    ; частное
    mov ebx, ecx ; EBX:= ECX
    idiv ebx ; EDX:EAX : EBX, результат в EAX, остаток в EDX

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