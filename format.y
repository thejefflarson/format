%{
#include <stdio.h>
#include <stdint.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
%}

%union {
  uint64_t number;
  char *string;
  char *ident;
}

%locations
%defines

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
  '(' IDENT { printf("calling %s\n", $2); } arguments ')'
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
yyerror(const char *s) {
  printf("guhwtf %s", s);
}