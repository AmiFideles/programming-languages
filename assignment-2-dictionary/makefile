ASM=nasm
FLAGS= -f elf64

%.o: %.asm
	${ASM} ${FLAGS} -o $@ $< 

main: lib.o dict.o main.o
	ld -o $@ $^

run: main
	./$^
PHONY: clean
clean: 
	rm -f main *.o