#ifndef FORMAT_H
#define FORMAT_H
#include <stdint.h>
// arena
typedef struct format_reg {
  uint8_t *region;
  uint8_t *start;
  uint8_t *limit;
  struct format_reg *next;
} format_reg_t;

typedef struct format_ctx {
  int yo;
  format_reg_t *reg;
} format_ctx_t;

#endif
