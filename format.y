%{
#include <stdio.h>
#include <stdint.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
void
yyerror(char const *msg);
%}

%union {
  uint64_t number;
  char *string;
  char *ident;
}

%require "3.0"
%locations
%defines
%pure-parser

%token <number> NUMBER;
%token <string> STRING;
%token <ident>  IDENT;

%%

format:
  expr
  ;

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

%%

void
yyerror(char const *msg) {
  printf("guhwtf %s\n", msg);
}