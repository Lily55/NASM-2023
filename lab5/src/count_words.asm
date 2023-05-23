bits 64;

%define STDOUT 1
%define WRITE 1
%define EXIT 60

%define MAX_LEN 255

section .data
    err_msg db "Invalid word position",10
    err_len equ $-err_msg

section .bss
    input_len resq 1
    input resq 1

section .text

global count_words
; extern print_exchanged

count_words:
    mov [input], rdi
    mov rax, [input]

    ret