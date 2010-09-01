require 'mkmf'
require 'erb'
require 'fileutils'

this_dir = File.expand_path(File.dirname(__FILE__))
$LIBS << " -lstdc++"
include FileUtils

##find_header('node.h')
#find_header('node/v8.h')
$defs << "-DRUBY_VERSION=#{RUBY_VERSION}"

create_header
create_makefile('ruby', File.join(this_dir, "ruby"))

if RUBY_VERSION < "1.9.0"
  version_specific_source = "ruby18.cpp"
else
  version_specific_source = "ruby19.cpp"
end

erb = ERB.new(File.read(File.join(File.dirname(__FILE__), "wscript.rb.erb")))

File.open(File.join(this_dir, "node/wscript"), "w") do |file|
  srcdir = File.join this_dir, 'node'
  blddir = File.join this_dir, 'node/build'
  version = File.read(File.join(this_dir, "../../VERSION")).strip 

  file.puts erb.result(binding)
end

Dir.chdir File.join(this_dir, "node") do
  #{Config::expand($INCFLAGS).gsub(/\$\(hdrdir\)/, $hdrdir).gsub(/\-I/, '')}
  cmd = "node-waf configure build -v"
  system(cmd) || raise("Could not build extension for node.js!")
end

ruby_node = Dir[File.join(this_dir, "**/ruby.node")].reject { |s| s =~ /\.svn/ }.shift
raise "Couldn't find newly-generated ruby.node!" unless ruby_node
destination = File.join(this_dir, "../..")
cp(ruby_node, destination)

=begin
g++ -I. -I/Users/colin/.rvm/rubies/ruby-1.9.2-p0/include/ruby-1.9.1/x86_64-darwin10.4.0 -I/Users/colin/.rvm/rubies/ruby-1.9.2-p0/include/ruby-1.9.1/ruby/backward -I/Users/colin/.rvm/rubies/ruby-1.9.2-p0/include/ruby-1.9.1 -I/Users/colin/projects/gems/node.rb/ext/ruby/ruby -DRUBY_EXTCONF_H=\"extconf.h\" -D_XOPEN_SOURCE -D_DARWIN_C_SOURCE   -fno-common -O3 -ggdb -Wextra -Wno-unused-parameter -Wno-parentheses -Wpointer-arith -Wwrite-strings -Wno-missing-field-initializers -Wshorten-64-to-32 -Wno-long-long  -fno-common -pipe   -o ruby.o -c /Users/colin/projects/gems/node.rb/ext/ruby/ruby/ruby.cpp
g++ -dynamic -bundle -o ruby.bundle ruby.o -L. -L/Users/colin/.rvm/rubies/ruby-1.9.2-p0/lib -L. -L/usr/local/lib
    -Wl,-undefined,dynamic_lookup -Wl,-multiply_defined,suppress -Wl,-flat_namespace  -lruby.1.9.1  -lpthread -ldl
    -lobjc  -lstdc++
# '/usr/bin/g++', '-g', '-fPIC', '-compatibility_version', '1', '-current_version', '1', '-DEV_MULTIPLICITY=0',
   '-I/Users/colin/.rvm/rubies/ruby-1.9.2-p0/include/ruby-1.9.1', '-I/usr/local/include/node', '../ruby19.cpp', '-c',
   '-o', 'default/ruby19_2.o'
cd -
=end

