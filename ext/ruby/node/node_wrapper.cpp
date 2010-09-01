#include <node.h>
#include "common.h"
#include <stdio.h>

using namespace node;

extern "C" void init(Handle<Object> target)
{
  init_ruby();

  HandleScope scope;
  Handle<Function> eval_func = FunctionTemplate::New(ruby_eval)->GetFunction();
  eval_func->SetName(String::New("eval"));
  target->Set(String::New("eval"), eval_func);
}
