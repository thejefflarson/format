#ifndef FORMAT_H
#define FORMAT_H
#include <stdint.h>
#include <stdlib.h>


typedef struct format_ctx {
  int yo;
  void *scanner;
} format_ctx_t;

int
format_init(format_ctx_t *ctx);

int
format_parse(format_ctx_t *ctx, uint8_t *buf, size_t length);

int
format_destroy(format_ctx_t *ctx);

#endif
