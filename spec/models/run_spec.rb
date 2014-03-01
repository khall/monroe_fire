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

    describe "year" do
      it "should give three runs" do
        Fabricate(:run, date: DateTime.parse('2001/06/01 00:00:00'))
        Fabricate(:run, date: DateTime.parse('2011/06/01 00:00:00'))
        Fabricate(:run, date: DateTime.parse('2011/06/01 00:00:00'))
        Fabricate(:run, date: DateTime.parse('2011/06/02 00:00:00'))
        Fabricate(:run, date: DateTime.parse('2007/06/01 00:00:00'))
        this_year = Run.year(2011)
        this_year.length.should == 3
      end

      it "should give one run when there is only one from selected year" do
        Fabricate(:run, date: DateTime.parse('2001/06/01 00:00:00'))
        Fabricate(:run, date: DateTime.parse('2011/06/01 00:00:00'))
        Fabricate(:run, date: DateTime.parse('2007/06/01 00:00:00'))
        this_year = Run.year(2011)
        this_year.length.should == 1
      end

      it "should give zero runs when there is no runs in selected year" do
        Fabricate(:run, date: DateTime.parse('2001/06/01 00:00:00'))
        Fabricate(:run, date: DateTime.parse('2011/06/01 00:00:00'))
        Fabricate(:run, date: DateTime.parse('2007/06/01 00:00:00'))
        this_year = Run.year(2008)
        this_year.length.should == 0
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

  describe "validation" do
    it "prevent duplicate alarm numbers from happening in the same year" do
      Fabricate(:run, date: Time.parse('2007/06/01 00:00:00'), alarm_number: 100)
      Run.all.length.should == 1
      r = Run.create(date: Time.parse('2007/06/03 00:00:00'), alarm_number: 100, run_type: 'fire',
                 number_of_responders: 5, time_out: 40, in_route_time: Time.parse('2007/06/03 00:06:00'),
                 arrived_time: Time.parse('2007/06/03 00:16:00'), in_quarters_time: Time.parse('2007/06/03 01:06:00'))
      r.valid?.should == false
      r.errors.messages.length.should > 0
      Run.all.length.should == 1
    end

    it "allows updates to existing runs" do
      r = Fabricate(:run, run_type: "fire", alarm_number: 100)
      r.run_type = "hazmat"
      r.valid?.should == true
      r.save
      Run.find(r.id).run_type.should == "hazmat"
    end
  end
end