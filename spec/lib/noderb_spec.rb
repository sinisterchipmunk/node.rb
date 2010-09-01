require 'spec_helper'

describe "Node.rb" do
  it "can evaluate Ruby code within Node.js" do
    node("context").should == '2'
  end
end
