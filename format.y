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

#define scanner ctx->scanner

void
yyerror(struct YYLTYPE *locp, format_ctx_t *ctx, char const *msg) {
  printf("guhwtf %s\n", msg);
}
%}

%pure-parser
%locations
%defines
%lex-param {void *scanner}
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
  '(' IDENT arguments ')' { printf("calling %s\n", $2); }
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

