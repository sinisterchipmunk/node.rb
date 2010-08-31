#include <ruby.h>
#include "common.h"

extern "C"
void Init_ruby(void) {
}

void sayhi(void)
{
  rb_funcall(rb_cObject, rb_intern("puts"), 1, rb_str_new2("Hello there!!!!"));
}
