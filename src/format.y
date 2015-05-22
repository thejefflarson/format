%{
#include <stdio.h>
#include <stdint.h>
#include "format.h"
%}

%union {
  uint8_t  u8;
  uint16_t u16;
  uint32_t u32;
  char *string;
}

%{
int
yylex(YYSTYPE* lvalp, YYLTYPE* llocp, void *scanner);

void
yyerror(struct YYLTYPE *locp, void *scanner, format_ctx_t *ctx, char const *msg) {
  printf("guhwtf %s\n", msg);
}
%}

%pure-parser
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

%destructor { free($$); } <string>;

%start format
%%

format: expr END { printf("format\n"); };

expr:
  expr atom
  | { printf("atom\n");}
  ;

atom:
  '(' IDENT arguments ')' { ctx->yo++; printf("calling %s %i\n", $IDENT, ctx->yo); free($IDENT); }
  ;

argument:
  U8       { printf("u8 %i\n", $1); }
  | U16    { printf("u16 %i\n", $1); }
  | U32    { printf("u32 %i\n", $1); }
  | STRING { printf("string %s\n", $1); free($1); }
  | atom
  ;

arguments:
  arguments argument { printf("argument list\n"); }
  | { printf("argument\n"); }
  ;

