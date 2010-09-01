#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), "../lib/node")
node = Node.new(*ARGV)

# node.run executes invokes node.js but collects the output; the user will expect
# the output in stdout when invoking this script so we have to do it this
# way instead
system node.command 
