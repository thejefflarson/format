%{
#include "format.tab.h"
%}

%option noyywrap
%option bison-bridge
%option bison-locations
%option reentrant
%option yylineno

%%
[0-9]{1,64} {
  char *end = yytext + yyleng;
  yylval->number = strtoull(yytext, &end, 10);
  return NUMBER;
}

[a-z]+ {
  yylval->ident = strndup(yytext, yyleng);
  return IDENT;
}

\"(\\\\.|[^\"])*\" {
  yylval->string = strndup(yytext, yyleng);
  return STRING;
}

[\(\)] {
  return yytext[0];
}

[ \t\n]+

. {
  return ERROR;
}
%%

#include <stdio.h>

int
main(){
  void *scanner;
  yylex_init(&scanner);

  do {
    if(yyparse(scanner)) break;
  } while (!feof(stdin));

  yylex_destroy(scanner);
}