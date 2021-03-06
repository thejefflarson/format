CFLAGS = -g -Wall -Wextra -pedantic -std=c99 -I./build/ -I./src/ -I./include/ -D_POSIX_C_SOURCE=200809L

all: build/format

build:
	mkdir build

build/format.tab.c build/format.tab.h: src/format.y src/format.c build
	bison -r all $< -o $@

build/lex.yy.c: src/format.l build/format.tab.c build/format.tab.h src/format.c include/format.h src/arena.h src/ht.h src/list.h build
	flex -o $@ $<

build/format: test/test.c build/format.tab.c build/lex.yy.c src/arena.c src/ht.c src/list.c
	$(CC) $^ $(CFLAGS) -o $@

clean:
	rm -rf build

.PHONY: clean
