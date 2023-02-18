%include "lib.inc"



section .text
global find_word
;принимает в rdi - указатель на нуль-терминированную строку. rsi указывает на начало словаря. 
;find word пройдет по всему словарю в поисках подходящего значения.
;Если подходящее вхождение найдено, вернёт адрес начало вхождения в словарь, иначе вернёт 0
find_word:
    .loop:
        cmp rsi,0 ;Если указать 0, то значит в словаре не найден ключ. (один из вариантов, когда словарь вообще пустой)
        je .not_found
        push rdi
        push rsi
        add rsi,8 ;перемещаем указатель на ключ 
        call string_equals 
        pop rsi
        pop rdi
        cmp rax,1 ;в rax вернется 1, если строки одинаковые
        je .found
        mov rsi, [rsi] ;положил в rsi указатель на следующий объект
        jmp .loop     
    .found:
        mov rax, rsi 
        ret
    .not_found:    
        mov rax,0
        ret
