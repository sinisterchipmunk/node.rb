#include <ruby.h>
#include "common.h"

extern "C"
void Init_ruby(void) {
  /* not used at this time */
}

/* protected ruby_eval function, this is always wrapped with rb_protect */
static VALUE p_ruby_eval(VALUE code)
{
  return rb_eval_string(StringValuePtr(code));
}

Handle<Value> ruby_eval(const Arguments &args)
{
  if (args.Length() != 1) return ThrowException(String::New("Expected 1 argument"));
  String::Utf8Value code(Handle<String>::Cast(args[0]));
  
  int error;
  VALUE ruby_code = rb_str_new2(ToCString(code));
  VALUE result = rb_protect(p_ruby_eval, ruby_code, &error);
  
  if (error)
  {
    VALUE message = rb_funcall(rb_gv_get("$!"), rb_intern("message"), 0);
    return ThrowException(String::New(StringValuePtr(message)));
  }
  
  // TODO translate Ruby into JS using Tomato!
  VALUE message = rb_funcall(result, rb_intern("inspect"), 0);
  char *ptr = StringValuePtr(message);
  return String::New(ptr);
}
