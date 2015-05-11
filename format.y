%{
#include <stdio.h>
#include <stdint.h>
extern int yylex();
extern int yyparse();
%}

%union {
  uint64_t number;
  char *string;
  char *ident;
}

%{
void
yyerror(struct YYLTYPE *locp, void *scanner, char const *msg) {
  printf("guhwtf %s\n", msg);
}
%}

%pure-parser
%locations
%defines
%lex-param {void * scanner}
%parse-param {void * scanner}
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

