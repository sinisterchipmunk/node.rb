require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "node.rb"
    gem.summary = %Q{TODO: one-line summary of your gem}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "sinisterchipmunk@gmail.com"
    gem.homepage = "http://github.com/sinisterchipmunk/node.rb"
    gem.authors = ["Colin MacKenzie IV"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new(:spec) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_files = FileList['spec/**/*_spec.rb']
  end

  Spec::Rake::SpecTask.new(:rcov) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov = true
  end
rescue LoadError
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |spec|
  end
end

def each_extension(&block)
  Dir[File.join(File.dirname(__FILE__), "ext/*")].each do |path|
    chdir path, &block
  end
end

desc "make extensions"
task :make do
  each_extension do
    system("ruby extconf.rb") && system("make") || raise("make failed")
  end
end

namespace :make do
  desc "make clean"
  task :clean do
    Dir['*.node'].each { |f| rm f }
    each_extension do
      system("make clean")
      %w(build .lock-wscript wscript Makefile).each do |fi|
        system("find . -name \"#{fi}\" -exec rm -rf {} \\;")
      end
    end
  end
end

task :spec => [:check_dependencies, :make]
task :clean => 'make:clean'

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "node.rb #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
