CFLAGS = -g -Wall -Wextra -pedantic -std=c99 -I./build/ -I./src/ -I./include/

all: format

build:
	mkdir build

build/format.tab.c build/format.tab.h: src/format.y build
	bison -r all $< -o $@

build/lex.yy.c: src/format.l build/format.tab.c build/format.tab.h include/format.h build
	flex -o $@ $<

format: build/format.tab.c build/lex.yy.c
	$(CC) $^ $(CFLAGS) -o $@

clean:
	rm -rf build

.PHONY: clean
