

global exit
global string_length
global print_string
global print_error
global print_newline
global print_char
global print_int
global print_uint
global string_equals
global read_char
global read_line
global parse_uint
global parse_int
global string_copy

; Принимает код возврата и завершает текущий процесс
exit: 
    mov rax, 60 ; устанавливаем код syscall exit
    syscall



; Принимает указатель на нуль-терминированную строку, возвращает её длину
string_length:
    xor rax, rax
    .loop:
        cmp byte[rdi+rax], 0 ; проверяем на 0 текущий элемент
        je .end ;если 0,  то выходим из цикла
        inc rax 
        jmp .loop
    .end:
        ret

; Принимает указатель на нуль-терминированную строку, выводит её в stdout
print_string:
    push rdi
    call string_length ; в rax вернется длина строки
    pop rsi ; записываем в rsi адрес строки
    mov rdi, 1 ; дескриптор stdout
    mov rdx, rax ; 
    mov rax,1  ; syscall write
    syscall
    ret    

print_error:
    push rdi
    call string_length ; в rax вернется длина строки
    pop rsi ; записываем в rsi адрес строки
    mov rdi, 2 ; дескриптор stdout
    mov rdx, rax ; 
    mov rax,1  ; syscall write
    syscall
    ret        
; Принимает код символа и выводит его в stdout
print_char:
    push rdi
    mov rsi, rsp ; системный вызов берет адрес символа из rsi
    mov rax,1 ;syscall write
    mov rdi,1 ;дескриптор stdout
    mov rdx,1 
    syscall
    pop rdi
    ret

; Переводит строку (выводит символ с кодом 0xA)
print_newline:
    mov rdi, 0xA ; 0xA символ перевода строки
    jmp print_char

; Выводит беззнаковое 8-байтовое число в десятичном формате 
; Совет: выделите место в стеке и храните там результаты деления
; Не забудьте перевести цифры в их ASCII коды.
print_uint:
    push rbx
    mov rbx, 10 ; основание системы счисления
    mov rax, rdi 
    xor rcx, rcx
    dec rsp
    mov byte [rsp], 0 ; положили нуль терминатор
    .loop:
        xor rdx, rdx
        div rbx ;получаем десятичную цифру выводимого числа
        dec rsp ; резервируем место в стеке
        add dl, '0' ;превращаем цифру в ASCII код
        mov byte [rsp], dl ; 
        inc cx 
        test rax, rax ; проверяем записали ли мы все число?
        jne .loop 
    .end: 
    	mov rdi, rsp ; записываем в rdi адрес первого символа
    	push rcx
    	call print_string
    	pop rcx
    	add rsp, rcx ;восстанавливаем стэек поинтер
    	inc rsp 
    	pop rbx
    	ret




; Выводит знаковое 8-байтовое число в десятичном формате 
print_int:
    cmp rdi,0
    jge .print ;здесь проверяем знак переданного числа. Если >=0, то идем сall print_uint
    push rdi
    mov rdi, '-' ; перед print_char, сохраняем код знака '-' в rdi
    call print_char
    pop rdi
    neg rdi ;меняется знак
    .print:
        jmp print_uint
            

; Принимает два указателя на нуль-терминированные строки, возвращает 1 если они равны, 0 иначе
string_equals:
	xor rax, rax			
	xor rcx, rcx 	;i , очищаем для цикла
	xor r9, r9
	
    .loop:
    	mov r9b, byte [rdi+rcx]
    	cmp r9b, byte [rsi+rcx]	;проверяем a[i] и b[i]
    	
    	jne .not_equal		
    	
    	cmp r9b, 0
    	je .equal ; если все символы совпали, то возвращаем 1 в rax
    	
    	inc rcx
    	jmp .loop
    	
    .equal:
    	mov rax, 1		
    	
    .not_equal:
    	ret

; Читает один символ из stdin и возвращает его. Возвращает 0 если достигнут конец потока
read_char:
    mov rax,0 ;read syscall
    mov rdi,0 ; дескриптор stdin
    mov rdx, 1 
    push 0 ; положили пустой символ на стэк
    mov rsi, rsp 
    syscall 
    pop rax ;если все хорошо, то в rax будет нужный символ. Иначе вернется 0, который ранее положили. 
    ret 

; Принимает: адрес начала буфера, размер буфера
; Читает в буфер строку из stdin, пропуская пробельные символы в начале, .
; Пробельные символы это пробел 0x20, табуляция 0x9.
; Останавливается и возвращает 0 если слово слишком большое для буфера
; При успехе возвращает адрес буфера в rax, длину слова в rdx.
; При неудаче возвращает 0 в rax
; Эта функция должна дописывать к слову нуль-терминатор
read_line:
    xor rdx, rdx 
    mov r8, rdi ; положили в r8 адрес начала буфера
    mov r9, rsi ; положили в r9 размер буфера

    .loop:
        push rdx 
        call read_char 
        pop rdx
        cmp rax, 0 ; проверка на конец ввода
        je .end
        cmp rax, 0xA ; проверка на перевод строки
        je .end
        cmp rdx,0
        je .checker
        jmp .write_to_buffer
    .checker:
        cmp al, 0x20  ; проверка на пробел
        je .loop  
        cmp al, 0x9 ; проверка на табуляцию
        je .loop
    .write_to_buffer:
        cmp rdx, r9  ; проверяем заполнен ли буфер 
        jge .error 
        mov byte[r8 + rdx], al 
        inc rdx
        jmp .loop
    .error:
        xor rax, rax
        xor rdx, rdx
        ret
    .end:
        mov byte[r8 + rdx], 0 
        mov rax, r8 
        ret
; Возврат из функции 

; Принимает указатель на строку, пытается
; прочитать из её начала беззнаковое число.
; Возвращает в rax: число, rdx : его длину в символах
; rdx = 0 если число прочитать не удалось
parse_uint:
    xor rax, rax
    mov r9, 10 ; основание системы счисления
    xor rdx, rdx ; будем хранить количество цифр
    
	.loop:
    	cmp byte [rdi], '0' ; проверка на то, что символ является цифрой [0-9]
    	jb .end
    	cmp byte [rdi], '9'
    	ja .end
    	push rdx
    	mul r9 ; домножаем  число, чтобы сдвинуть разряд
    	pop rdx
        sub al, '0' 
    	add al, byte [rdi]
    	inc rdi ;перевод на следующий символ
        inc rdx
    	jmp .loop
	.end:
    	ret



; Принимает указатель на строку, пытается
; прочитать из её начала знаковое число.
; Если есть знак, пробелы между ним и числом не разрешены.
; Возвращает в rax: число, rdx : его длину в символах (включая знак, если он был) 
; rdx = 0 если число прочитать не удалось
parse_int:
    xor rax,rax
    xor rdx,rdx
    xor r9,r9
    mov r9b, byte[rdi] ; сохраняем  первый символ строки
    cmp r9b, '-' ; проверяем если первый символ строки равен '-'
    je .negative   
    .positive:
    	jmp parse_uint
    .negative:   
   	    inc rdi ;переводим указатель на следующий символ
    	call parse_uint
        neg rax ; берем отрицательное число
        dec rdi
        inc rdx 
    .end:
    	ret




; Принимает указатель на строку, указатель на буфер и длину буфера
; Копирует строку в буфер
; Возвращает длину строки если она умещается в буфер, иначе 0
string_copy:
    xor r9,r9
    xor rcx, rcx ; i
    push rcx
    push rdi
    call string_length
    pop rdi
    pop rcx
    cmp rax, rdx ; проверка длины буфера и длины строки
    ja .error
    .loop:
        mov r9b,byte[rdi+rcx] ; используем промежуточный регистр, чтоб скопировать символ 
        mov byte[rsi+rcx], r9b ; далее в буфер
        cmp rax, rcx
        je .end
        inc rcx
        jmp .loop
    .error:
        xor rax, rax
    .end:
        ret
