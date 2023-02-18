%define link 0 ;всегда указывает на начало словаря
%macro colon 2
    %ifstr %1 
        %ifid %2 
            %2: dq link ; сохраняем указатель на предыдующий элемент
            db %1, 0 ;записываем ключ
            %define link %2 ;перезаписали указатель на начало словаря
        %else
            %error "Второй аргумент должен быть меткой"
        %endif
    %else
        %error "Первый аргумент должен быть строкой"
    %endif   
%endmacro