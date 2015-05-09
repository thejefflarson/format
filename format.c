#include "mpc.h"

int
main() {
  mpc_parser_t *string  = mpc_new("string");
  mpc_parser_t *number  = mpc_new("number");
  mpc_parser_t *ident   = mpc_new("ident");
  mpc_parser_t *sexpr   = mpc_new("sexpr");
  mpc_parser_t *atom    = mpc_new("atom");
  mpc_parser_t *format  = mpc_new("format");

  mpc_err_t *err = mpca_lang(MPCA_LANG_PREDICTIVE,
    "string : /\"(\\\\.|[^\"])*\"/ ;"
    "number : /[0-9]+/ ;"
    "ident  : /[a-z]+/ ;"
    "sexpr  : '(' <atom> ')' ;"
    "atom   : <ident> (<number> | <string> | <sexpr>)* ;"
    "format : /^/ <sexpr> /$/ ;",
  string, number, ident, sexpr, atom, format, NULL);

  if(err != NULL) {
    mpc_err_print(err);
    mpc_err_delete(err);
    exit(1);
  }

  mpc_result_t r;
  if (mpc_parse_pipe("<sexp>", stdin, format, &r)) {
    mpc_ast_print(r.output);
    mpc_ast_delete(r.output);
    mpc_cleanup(6, string, number, ident, sexpr, atom, format);
  } else {
    mpc_err_print(r.error);
    mpc_err_delete(r.error);
    mpc_cleanup(6, string, number, ident, sexpr, atom, format);
    exit(1);
  }
}
