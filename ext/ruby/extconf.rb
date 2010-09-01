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
  cmd = "node-waf configure build"
  system(cmd) || raise("Could not build extension for node.js!")
end

ruby_node = Dir[File.join(this_dir, "**/ruby.node")].reject { |s| s =~ /\.svn/ }.shift
raise "Couldn't find newly-generated ruby.node!" unless ruby_node
destination = File.join(this_dir, "../..")
cp(ruby_node, destination)
