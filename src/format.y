%{
#include <stdio.h>
#include <stdint.h>

#include "arena.h"
#include "format.h"
#include "ht.h"
%}

%code requires {
  #include "list.h"
}

%union {
  uint8_t  u8;
  uint16_t u16;
  uint32_t u32;
  char *string;
  list_t *arguments;
  void *user_data;
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
%type <user_data> atom;

%start format
%%

format: atom END;

atom:
  '(' IDENT arguments ')' {
    // format_func_t *fn = ht_get(ctx->ht, $IDENT);
    // // check for error
    // $$ = fn(ctx, $arguments);
  }
  ;

argument:
  U8
  | U16
  | U32
  | STRING
  | atom
  ;

arguments: {
    list_t *list = list_new(ctx->arena);
    $$ = list;
  }
  | arguments argument {
    $$ = $1;
    list_push($1, $2);
  }
  ;

