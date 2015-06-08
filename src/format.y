%{
#include <stdio.h>
#include <stdint.h>
#include "format.h"
#include "arena.h"
#include "ht.h"
%}

%union {
  uint8_t  u8;
  uint16_t u16;
  uint32_t u32;
  char *string;
  list_t *arguments;
}

%{
int
yylex(YYSTYPE* lvalp, YYLTYPE* llocp, void *scanner);

void
yyerror(struct YYLTYPE *locp, void *scanner, format_ctx_t *ctx, char const *msg) {
  printf("guhwtf %s\n", msg);
}
%}

%require "3.0"
%define api.pure full
// %define api.push-pull push
%locations
%defines
%debug
%lex-param {void *scanner}
%parse-param {void *scanner}
%parse-param {format_ctx_t *ctx}
%error-verbose

%token <u8> U8 "8-bit number"
%token <u16> U16 "16-bit number"
%token <u32> U32 "32-bit number"
%token <string> STRING "string"
%token <string> IDENT "indentifier"
%token ERROR "character"
%token END 0 "end of file"

%type <arguments> arguments;
%type <arguments> argument;
%type <arguments> atom;

%start format
%%

format: atom END;

atom:
  '(' IDENT arguments ')' {
    format_func_t *fn = ht_get(ctx->ht, $IDENT);
    // check for error
    $$ = fn(ctx, $arguments);
  }
  ;

argument:
  U8       { printf("u8 %i\n", $1); }
  | U16    { printf("u16 %i\n", $1); }
  | U32    { printf("u32 %i\n", $1); }
  | STRING { printf("string %s\n", $1); }
  | atom
  ;

arguments: {
    list_t *list = arena_malloc(sizeof(list_t));
    // check for error
    list_init(list);
    $$ = list;
  }
  | arguments argument {
    $$ = $1;
    list_push($1, $2);
  }
  ;

