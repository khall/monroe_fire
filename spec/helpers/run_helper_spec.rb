require 'spec_helper'

describe RunHelper do
  describe "pretty_time" do
    it "formats 5 minutes to '0:05'" do
      helper.pretty_time(5).should == '0:05'
    end
  end
end