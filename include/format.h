#ifndef FORMAT_H
#define FORMAT_H

// arena
typedef struct format_reg {
  void *region;
  void *start;
  void *limit;
  struct format_reg *next;
} format_reg_t;

typedef struct format_ctx {
  int yo;
  format_reg_t *reg;
} format_ctx_t;

#endif
