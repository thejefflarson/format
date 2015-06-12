%{
#include "format.h"
#include "format.tab.h"
#include <arpa/inet.h>
#include <inttypes.h>
#define parsenum(size, conv) \
  do { \
    yylval->u##size = 0; \
    for(int i = (size / 8) - 1; i >= 0; i--, ++yyleng) \
      yylval->u##size |= input(yyscanner) << (i * 8); \
    return U##size; \
  } while(0);
%}

%option noyywrap
%option bison-bridge
%option bison-locations
%option reentrant
%option extra-type="format_ctx_t *"

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
  yylval->ident = arena_malloc(yyextra->arena, yyleng);
  memcpy(yylval->ident, yytext, yyleng - 1);
  yylval->ident[yyleng] = '\0';
  return IDENT;
}

` {
  uint16_t val = ((uint8_t)input(yyscanner) << 8) | (uint8_t)input(yyscanner);
  yyleng += 2;

  yylval->string = calloc(val, sizeof(uint8_t));
  for(int i = 0; i < val; i++, ++yyleng)
    yylval->string[i] = input(yyscanner);

  return STRING;
}

[\(\)] {
  return yytext[0];
}

(.|\n) {
  return ERROR;
}
%%

#include <stdio.h>
#include "format.c"

int
format_parse(format_ctx_t *ctx, uint8_t *buf, size_t length) {
  do {
    if(yyparse(ctx->scanner, ctx)) break;
  } while (!feof(stdin));

  return 0;
}