%{
#include "format.h"
#include "format.tab.h"
#include <arpa/inet.h>
#define parsenum(size, conv) \
  do { \
    uint##size##_t val; \
    uint##size##_t *p = &val; \
    for(size_t i = 0; i < sizeof(uint##size##_t); i++, ++yyleng) \
      p[i] = input(yyscanner); \
    yylval->u##size = ntoh##conv(val); \
    return U##size; \
  } while(0);
%}

%option noyywrap
%option bison-bridge
%option bison-locations
%option reentrant
%option yylineno

%%
~ {
  yyleng++;
  yylval->u8 = input(yyscanner);
  return U8;
}

! {
  parsenum(16, s);
}

@ {
  parsenum(32, l);
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
  void *scanner = NULL;
  yylex_init(&scanner);

  format_ctx_t ctx;
  ctx.yo = 0;
  do {
    if(yyparse(scanner, &ctx)) break;
  } while (!feof(stdin));

  yylex_destroy(scanner);
}