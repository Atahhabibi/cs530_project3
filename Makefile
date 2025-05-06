# Atah Habibi - 130699943
scanner: parser.tab.o lex.yy.o
	@gcc -o scanner parser.tab.o lex.yy.o -ll

parser.tab.c parser.tab.h: parser.y
	@bison -d parser.y

lex.yy.c: scanner.l
	@flex scanner.l

parser.tab.o: parser.tab.c
	@gcc -c parser.tab.c

lex.yy.o: lex.yy.c
	@gcc -c lex.yy.c

clean:
	@rm -f scanner parser.tab.* lex.yy.c *.o
