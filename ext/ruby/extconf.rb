require 'mkmf'
require 'fileutils'

$LIBS << " -lstdc++"

include FileUtils

TARGET = 'ruby'
FILES = 'node_wrapper.cpp'
VERSION = File.read(File.join(File.dirname(__FILE__), "../../VERSION")).strip

find_header('node.h')
find_header('node/v8.h')

File.open("node/wscript", "w") do |file|
  file.puts <<-end_file
srcdir = '.'
blddir = 'build'
VERSION = '#{VERSION}'

def set_options(opt):
  opt.tool_options('compiler_cxx')

def configure(conf):
  conf.check_tool('compiler_cxx')
  conf.check_tool('node_addon')
  conf.env['LIBPATH_RUBY'] = '#{File.dirname(__FILE__)}'
  conf.env['LIB_RUBY'] = 'ruby'

def build(bld):
  obj = bld.new_task_gen('cxx', 'shlib', 'node_addon')
  obj.target = '#{TARGET}'
  obj.source = '#{FILES}'
  obj.uselib = 'RUBY'
end_file
end

# Don't think we need a Ruby extension since we're actually extending Node to use Ruby itself.
#create_header
create_makefile('ruby')

Dir.chdir File.expand_path(File.join(File.dirname(__FILE__)), "node") do
  system("node-waf configure build") || raise("Could not build extension for node.js!")
end
cp(File.expand_path(File.join(File.dirname(__FILE__)), "node/build/default/ruby.node"),
                    File.join(File.dirname(__FILE__), "../.."))
