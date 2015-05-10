%{
#include "format.tab.h"
%}

%option noyywrap bison-bridge bison-locations batch

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
%%

#include <stdio.h>

int
main(){
  yyin = stdin;
  do {
    yyparse();
  } while (!feof(yyin));
}