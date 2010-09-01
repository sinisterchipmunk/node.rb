$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

module NodeExecution
  def node(filename)
    node = Node.new(File.join(File.dirname(__FILE__), "support/nodes", "#{filename}.js"))
    puts "Executing:\n  #{node.command}"
    node.run
  end
end

begin
  require 'spec'
  require 'spec/autorun'
  require 'node.rb'
  
  Spec::Runner.configure do |config|
    config.include NodeExecution
  end
rescue LoadError
  require 'rspec'
  require 'node.rb'
  
  RSpec.configure do |config|
    config.include NodeExecution
  end
end
