#include <node.h>
#include <v8.h>
#include "common.h"

using namespace node;
using namespace v8;

extern "C" void init(Handle<Object> target)
{
  init_ruby();

  HandleScope scope;
  target->Set(String::New("hello"), String::New("World"));
}
