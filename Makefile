CFLAGS = -Wall -Wextra -pedantic

all: format

format.tab.c format.tab.h: format.y
	bison -r all $<

lex.yy.c: format.l format.tab.c format.tab.h
	flex $<

format: format.tab.c lex.yy.c
	$(CC) $^ $(CFLAGS) -o $@

clean:
	rm format.tab.c format.tab.h format lex.yy.c

.PHONY: clean