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

  describe "projected_trend" do
    # (calls to date (30) - calls in previous 10 days (30)) / (day of year - 10)
    # 30 / 30 = 1 call per day
    # short-term projection is that we are behind ten calls
    it "determines that few calls have been coming in lately and rates the trend as being up" do
      Time.stub(:now).and_return(Time.parse('2013/02/10 16:00:00'))
      trend = helper.projected_trend(31, 0)
      trend.should == "Significant increase (Trend value: -10)"
    end

    it "determines that lots of calls have been coming in lately and rates the trend as being down" do
      Time.stub(:now).and_return(Time.parse('2013/02/10 16:00:00'))
      trend = helper.projected_trend(6, 10)
      trend.should == "Significant decrease (Trend value: 8)"
    end
  end

  describe "projected_runs" do
    it "estimates 365 runs on January 1 when there's been one call" do
      runs = [Fabricate(:run, date: Time.parse('2013/01/01 12:00:00'))]
      Time.stub(:now).and_return(Time.parse('2013/01/01 15:00:00'))
      projected_runs = helper.projected_runs(runs)
      projected_runs.should == 365
    end

    it "estimates 730 runs on January 1 when there have been two calls" do
      runs = [Fabricate(:run, date: Time.parse('2013/01/01 12:00:00')),
              Fabricate(:run, date: Time.parse('2013/01/01 15:00:00'))
      ]
      Time.stub(:now).and_return(Time.parse('2013/01/01 16:00:00'))
      projected_runs = helper.projected_runs(runs)
      projected_runs.should == 730
    end

    it "estimates 30 runs on January 12 when there's been one call" do
      runs = [Fabricate(:run, date: Time.parse('2013/01/01 12:00:00'))
      ]
      Time.stub(:now).and_return(Time.parse('2013/01/12 16:00:00'))
      projected_runs = helper.projected_runs(runs)
      projected_runs.should == 30
    end

    it "estimates 12 runs on January 30 when there's been one call" do
      runs = [Fabricate(:run, date: Time.parse('2013/01/01 12:00:00'))
      ]
      Time.stub(:now).and_return(Time.parse('2013/01/30 16:00:00'))
      projected_runs = helper.projected_runs(runs)
      projected_runs.should == 12
    end
  end
end