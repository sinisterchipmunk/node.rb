#ifndef NODE_RB_COMMON_H
#define NODE_RB_COMMON_H

#include "../extconf.h"
#include <v8.h>

using namespace v8;

#define ToCString(value) (*value ? *value : "<string conversion failed>")

extern void init_ruby(void);

extern Handle<Value> ruby_eval(const Arguments &args);

#endif//NODE_RB_COMMON_H
