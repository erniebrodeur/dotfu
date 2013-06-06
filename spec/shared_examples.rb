require 'spec_helper.rb'

shared_examples "attribute override" do
  it "will always return a value" do
    self.should be ''
  end

  it "will return an override after set"
end

