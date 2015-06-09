#include "arena.h"
#include "format.h"
#include "ht.h"

int
format_init(format_ctx_t *ctx) {
  ctx->arena      = arena_create();
  ctx->func_table = ht_new(256, 32);
  return yylex_init_extra(ctx, &ctx->scanner);
}

int
format_destroy(format_ctx_t *ctx) {
  arena_destroy(ctx->arena);
  ht_free(ctx->func_table);
  return yylex_destroy(ctx->scanner);
}
