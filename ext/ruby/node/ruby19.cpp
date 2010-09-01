#include <ruby.h>
#include "common.h"

/* This file initializes Ruby when compiled against 1.9.x header files. */

void init_ruby(void)
{
  // FIXME: a Ruby error causes a segfault. This is because we aren't wrapping with rb_protect and re-raising in Node.
  rb_funcall(rb_cObject, rb_intern("puts"), 1, rb_str_new2("Ruby initialized from within node.js"));
}
