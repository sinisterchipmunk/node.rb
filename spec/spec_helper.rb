$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'spec'
require 'spec/autorun'
require 'node-rb'

module NodeExecution
  def node(filename)
    node = Node.new(File.join(File.dirname(__FILE__), "support/nodes", "#{filename}.js"))
    puts "Executing:\n  #{node.command}"
    node.run
  end
end

Spec::Runner.configure do |config|
  config.include NodeExecution
end
