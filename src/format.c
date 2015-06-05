int
format_init(format_ctx_t *ctx) {
  return yylex_init(&ctx->scanner);
}

int
format_destroy(format_ctx_t *ctx) {
  return yylex_destroy(ctx->scanner);
}
