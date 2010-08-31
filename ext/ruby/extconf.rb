require 'mkmf'
require 'fileutils'

this_dir = File.expand_path(File.dirname(__FILE__))
$LIBS << " -lstdc++"

_version = File.read(File.join(this_dir, "../../VERSION")).split
include FileUtils

##find_header('node.h')
#find_header('node/v8.h')
#find_library("v8", nil)

#create_header
create_makefile('ruby', File.join(this_dir, "ruby"))

Dir.chdir File.join(this_dir, "node") do
  File.open(File.join(this_dir, "node/wscript"), "w") do |file|
    file.puts <<-end_file
srcdir = '#{File.join this_dir, 'node'}'
blddir = '#{File.join this_dir, 'node/build'}'
VERSION = '#{_version}'

def set_options(opt):
  opt.tool_options('compiler_cxx')

def configure(conf):
  conf.check_tool('compiler_cxx')
  conf.check_tool('node_addon')
  conf.env['LIBPATH_RUBY'] = '#{Config::expand(CONFIG["libdir"])}'
  conf.env['LIB_RUBY'] = 'ruby'

def build(bld):
  obj1 = bld.new_task_gen('cxx', 'objects', 'node_addon')
  obj1.target = 'wrapper'
  obj1.source = 'node_wrapper.cpp'
  obj1.uselib = 'RUBY'
  
  obj2 = bld.new_task_gen('cxx', 'shlib', 'node_addon')
  obj2.target = 'ruby'
  obj2.source = 'ruby.cpp'
  obj2.uselib = 'RUBY'
  obj2.add_objects = 'wrapper'
  #obj2.uselib_local = 'wrapper'
  obj2.includes = '#{Config::expand($INCFLAGS).gsub(/\$\(hdrdir\)/, $hdrdir).gsub(/\-I/, '')}'

    end_file
  end
  system("node-waf configure build") || raise("Could not build extension for node.js!")
end

ruby_node = Dir[File.join(this_dir, "**/ruby.node")].reject { |s| s =~ /\.svn/ }.shift
raise "Couldn't find newly-generated ruby.node!" unless ruby_node
destination = File.join(this_dir, "../..")
cp(ruby_node, destination)
