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

  describe "fill_in_missing" do
    it "should fill in missing values in hash with zeros" do
      list = helper.fill_in_missing({4 => 4, 5 => 2}, 6)
      list.should == {0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 4, 5 => 2, 6 => 0}
    end

    it "should fill in missing values in Hash.new(0) with zeros" do
      hash = Hash.new(0)
      hash[4] = 2
      hash[5] = 2
      list = helper.fill_in_missing(hash, 6)
      list.should == {0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 2, 5 => 2, 6 => 0}
    end
  end

  #describe "chart" do
  #  it "should draw a blank chart" do
  #    data = {monday: 0, tuesday: 0, wednesday: 0, thursday: 0, friday: 0, saturday: 0, sunday: 0}
  #    html = helper.chart(data)
  #    html.should =~ //
  #  end
  #
  #  it "should draw a regular chart " do
  #    data = {monday: 5, tuesday: 4, wednesday: 8, thursday: 0, friday: 2, saturday: 4, sunday: 1}
  #    html = helper.chart(data)
  #    html.should =~ //
  #  end
  #end
end