require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "NodeRails" do
  it "does something with node.rb.js" do
    node("context").should == '2'
  end
end
