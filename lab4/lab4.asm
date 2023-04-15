%include "lib.asm"

section .data
; MAS dw 3, 9, 2, 2, 5, 8, 1, 5, -1, 8, 10, 15, 9, 5, -1
ExitMsg db "",10
lenExit equ $-ExitMsg
EnterMsg db "Enter the array which is 25 or smaller numbers: ", 10
lenEnter equ $-EnterMsg

err_num db "Only numbers and spaces can be entered", 10
err_num_len equ $-err_num

ResultMsg db "New array is: ", 10
lenResult equ $-ResultMsg

input times 255 db 0
len_input equ $-input

section .bss
NewUnicMAS resw 25
NewMAS resw 25
OutBuf resb 50
MAS resw 25

section .text
global _start

_start:

    mov rax, 1
    mov rdi, 1
    mov rsi, EnterMsg
    mov rdx, lenEnter
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, len_input
    syscall

    mov rcx, rax
    xor rdx, rdx
    xor r10, r10

process_line:
    cmp byte[input + rdx], 10
    je process_number

    cmp byte[input + rdx], ' '
    jne next

    mov byte[input + rdx], 10
    cmp r10, rdx
    jne process_number
    jmp next

process_number:
    push rdx

    call StrToInt64
    cmp rbx, 0
    jne error_num

    mov [MAS + 2 * rdi], rax
    inc rdi

    pop rdx
    mov r10, rdx
    inc r10
    lea rsi, [input + r10]

next:
    inc rdx
    loop process_line



;logic

    mov ebx, 0
    mov ecx, edi
    mov r10, rdi
    xor rsi, rsi ; Unic counter
    xor rdi, rdi ; Replicated counter

cycle1:         ; цикл прохода по массиву MAS в поиске уникальных элементов
    push rcx
    mov dx, 0
    mov rcx, r10
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
new_array1:
    mov ax, [ebx*2 + NewUnicMAS]
    mov [ebx*2 + MAS], ax
    inc ebx
    loop new_array1

    mov edx, ebx
    mov ebx, 0
    mov rcx, rdi
new_array2:
    mov ax, [ebx*2 + NewMAS]
    mov [edx*2 + MAS], ax
    inc ebx
    inc edx
    loop new_array2


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

    ; Result Message
    mov rax, 1
    mov rdi, 1
    mov rsi, ResultMsg
    mov rdx, lenResult
    syscall


    mov ebx, 0
    mov rcx, r10
output_cycle:
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
    loop output_cycle  

    ; write ExitMsg
    mov     rax, 1        
    mov     rdi, 1        
    mov     rsi, ExitMsg  
    mov     rdx, lenExit  
    syscall  

exit:    ;exit
    mov rax, 60
    xor rdi, rdi
    syscall

error_num:
    mov rax, 1
    mov rdi, 1   
    mov rsi, err_num
    mov rdx, err_num_len
    syscall
    jmp exit