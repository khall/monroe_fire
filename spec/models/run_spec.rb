require File.dirname(__FILE__) + '/../spec_helper'

describe Run do
  describe "scopes" do
    describe "this_year" do
      it "should give no runs when all runs are from other years" do
        Fabricate(:run, date: Time.now - 1.year)
        this_year = Run.this_year
        this_year.length.should == 0
      end

      it "should give one run when there is only one from this year" do
        Fabricate(:run, date: Time.now)
        Fabricate(:run, date: Time.now + 1.year)
        Fabricate(:run, date: Time.now - 1.year)
        this_year = Run.this_year
        this_year.length.should == 1
      end
    end
  end

  describe "total_time_out" do
    it "should return '0:00' for zero minutes out" do
      r = Fabricate(:run, date: Time.now, in_quarters_time: Time.now)
      r.total_time_out().should == 0
    end

    it "should return '0:05' for five minutes out" do
      r = Fabricate(:run, date: Time.now, in_quarters_time: Time.now + 5.minutes)
      r.total_time_out().should == 5
    end

    it "should return '3:30' for 3.5 hours out" do
      r = Fabricate(:run, date: Time.now, in_quarters_time: Time.now + 3.hours + 30.minutes)
      r.total_time_out().should == 210
    end
  end
end