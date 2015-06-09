#ifndef FORMAT_H
#define FORMAT_H
#include <stdint.h>
#include <stdlib.h>
#include "ht.h"
#include "arena.h"

typedef struct format_ctx {
  void *scanner;
  ht_t *func_table;
  arena_t *arena;
} format_ctx_t;

int
format_init(format_ctx_t *ctx);

int
format_parse(format_ctx_t *ctx, uint8_t *buf, size_t length);

int
format_destroy(format_ctx_t *ctx);

#endif
