#include <format.h>

int
main(){
  format_ctx_t ctx;
  format_init(&ctx);
  uint8_t *c = NULL;
  format_parse(&ctx, c, 0);
  format_destroy(&ctx);
  return 0;
}
