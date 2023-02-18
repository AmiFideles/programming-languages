%include "lib.inc"
%include "colon.inc"
%include "words.inc"


%define buffer_size 255

extern find_word

section .rodata
message_too_long: db "Слишком длинная строка. Она должна быть меньше 256", 0
message_no_such_key: db  "Такого ключа нет в словаре", 0

section .bss
    buffer: resb buffer_size


section .text
global _start

_start:
    mov rsi, buffer_size; указываем размер 
    mov rdi, buffer; указываем куда нужно считать
    call read_line
    test rax,rax 
    je .too_long ;если введенная строка больше чем размер буфера, то выводим необходимое сообщение

    mov rdi, buffer  
    mov rsi, link
    call find_word
    test rax, rax ;если получили 0, значит ключ не нашелся в словаре
    je .no_such_key
.success:
    mov rdi, rax ;в строках ниже нам нужно добраться до значения. Сейчас rax указывает на начало найденного элемента
    add rdi, 8 ;переместили указатель на ключ
    push rdi
    call string_length
    pop rdi
    add rdi, rax
    inc rdi
    call print_string
    call print_newline
    xor rdi, rdi 
    call exit
.too_long:
    mov rdi, message_too_long
    jmp .error
.no_such_key:
    mov rdi, message_no_such_key
    jmp .error
.error:
    call print_error
    call print_newline
    mov rdi,1
    call exit
