%{
#include "format.tab.h"
%}

%option noyywrap

%%
[0-9]{1,64} {
  yyval.ival = strtoull(yytext, yytext + yyleng, 10);
  return NUMBER;
}

[a-z]+ {
  yyval.ident = strndup(yytext, yyleng);
  return INDENT;
}

\"(\\\\.|[^\"])*\" {
  yyval.string = strndup(yytext, yyleng);
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
  yylex();
}