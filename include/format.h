#ifndef FORMAT_H
#define FORMAT_H
#include <stdint.h>
#include <stdlib.h>

typedef struct format_ctx {
  // opaque to the user
  void *scanner;
  void *func_table;
  void *arena;
} format_ctx_t;


typedef enum {
  FORMAT_8,
  FORMAT_16,
  FORMAT_32,
  FORMAT_S
} format_type_t;

typedef struct {
  format_type_t type;
  union {
    uint8_t  u8;
    uint16_t u16;
    uint32_t u32;
    char *string;
  };
} format_item_t;

int
format_init(format_ctx_t *ctx);

int
format_parse(format_ctx_t *ctx, uint8_t *buf, size_t length);

int
format_destroy(format_ctx_t *ctx);

#endif
