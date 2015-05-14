%{
#include <stdio.h>
#include <stdint.h>
#include "format.h"

%}

%union {
  uint64_t number;
  char *string;
  char *ident;
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
%lex-param {void *scanner}
%parse-param {void *scanner}
%parse-param {format_ctx_t *ctx}
%error-verbose

%token <number> NUMBER "number";
%token <string> STRING "string";
%token <ident>  IDENT "indentifier";
%token ERROR "character";
%token END 0 "end of file";

%%

expr:
  expr atom
  | atom
  ;

atom:
  '(' IDENT arguments ')' { ctx->yo++; printf("calling %s %i\n", $2, ctx->yo); }
  ;

argument:
  NUMBER   { printf("number %llu\n", $1); }
  | STRING { printf("string %s\n", $1); }
  | atom
  ;

arguments:
  arguments argument
  | argument
  ;

