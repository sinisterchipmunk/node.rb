require File.join(File.dirname(__FILE__), "../ext/ruby/ruby")

class Node
  # the value of NODE_PATH. This is an array.
  attr_accessor :path

  # the name of the stock node.js executable, which is normally just "node"
  attr_accessor :exec_name

  # If true, prints additional debug output. Defaults to false.
  attr_accessor :node_debug

  # If set true, loads modules in their own global contexts.
  attr_accessor :module_contexts

  # Array of command-line arguments for node.js.
  attr_accessor :opts

  def initialize(file)
    @file = file
    @path = default_node_path
    @exec_name = "node"
    @node_debug = false
    @module_contexts = false
    @opts = []
  end

  def run
    system(command)
  end

  # Constructs the execution command.
  def command
    parts = [construct_path, construct_debug, construct_contexts, construct_name, construct_opts, @file]
    parts.reject { |a| a.nil? || a.length == 0 }.join " "
  end

  class << self
    # Returns the path to the node.rb gem.
    def path_to_gem
      File.expand_path(File.join(File.dirname(__FILE__), ".."))
    end
  end

  # Returns the path to the node.rb gem.
  def path_to_gem
    self.class.path_to_gem
  end

  private
  def construct_path
    path.empty? ? "" : "NODE_PATH=#{path.join(":")}"
  end

  def construct_debug
    node_debug ? "NODE_DEBUG" : ""
  end

  def construct_contexts
    module_contexts ? "NODE_MODULE_CONTEXTS=1" : ""
  end

  def construct_name
    exec_name
  end

  def construct_opts
    opts.join(" ")
  end

  def default_node_path
    path = [path_to_gem] # for node.rb extensions
    if ENV['NODE_PATH']
      path.unshift ENV['NODE_PATH']
    else
      path.unshift "$NODE_PATH"
    end
    path
  end
end
