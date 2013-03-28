require 'spec_helper'

describe RunHelper do
  describe "pretty_time" do
    it "formats 5 minutes to '0:05'" do
      helper.pretty_time(5).should == '0:05'
    end

    it "formats 5 hours to '5:00'" do
      helper.pretty_time(5, hours: true).should == '5:00'
    end

    it "formats 5 hours to '05:00' with padding" do
      helper.pretty_time(5, hours: true, pad: true).should == '05:00'
    end
  end
end