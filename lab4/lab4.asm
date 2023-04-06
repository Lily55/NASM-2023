%include "lib.asm"

section .data
MAS dw 3, 9, 2, 2, 5, 8, 1, 5, -1, 8, 10, 15, 9, 5, -1
ExitMsg db "",10
lenExit equ $-ExitMsg

section .bss
NewUnicMAS resw 15
NewMAS resw 15
OutBuf resb 10

section .text
global _start

_start:

    mov ebx, 0
    mov ecx, 15
    mov rsi, 0
    mov rdi, 0

cycle1:         ; цикл прохода по массиву MAS в поиске уникальных элементов
    push rcx
    mov dx, 0
    mov ecx, 15
    mov ax, [ebx*2 + MAS]
    push rbx
    mov ebx, 0
cycle2:         ; цикл в котором происходит сравнение
        ; текущего элемента цикла1 со всеми
    cmp ax, [ebx*2 + MAS] ; элементами массива MAS для выявления уникального элемента
    je plus
    jmp next1
plus:
    inc dx      ; при нахождении повторения увеличиваем счётчик на 1
next1:
    inc ebx 
    loop cycle2

    cmp dx, 2   ; если счётчик равен 1, то это уникальный элемент
    jl dobU
    jge dobR
    jmp next2
dobU:
    mov [rsi*2 + NewUnicMAS], ax    ; добавляем уникальные элементы в NewUnicMAS
    inc rsi
    jmp next2
dobR:
    mov [rdi*2 + NewMAS], ax    ; добавляем повторяющиеся элменеты в NewMAS
    inc rdi
next2:
    pop rbx
    inc ebx
    pop rcx
    loop cycle1

    mov ebx, 0
    mov rcx, rsi
cycle5:
    mov ax, [ebx*2 + NewUnicMAS]
    mov [ebx*2 + MAS], ax
    inc ebx
    loop cycle5

    mov edx, ebx
    mov ebx, 0
    mov rcx, rdi
cycle6:
    mov ax, [ebx*2 + NewMAS]
    mov [edx*2 + MAS], ax
    inc ebx
    inc edx
    loop cycle6


;     mov ebx, 0
;     mov ecx, 12
; cycle3:
;     mov ax, [ebx*2 + NewUnicMAS]
;     inc ebx
;     push rcx

;     ; конвертируем частное из целого в строку
;     mov esi, OutBuf
;     cwde
;     call IntToStr64

;     ; write
;     mov edx, eax
;     mov eax, 1        
;     mov edi, 1        
;     syscall 

;     pop rcx
;     loop cycle3

; ;end:
;     ; write ExitMsg
;     mov     rax, 1        
;     mov     rdi, 1        
;     mov     rsi, ExitMsg  
;     mov     rdx, lenExit  
;     syscall  

    mov ebx, 0
    mov ecx, 15
cycle4:
    mov ax, [ebx*2 + MAS]
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