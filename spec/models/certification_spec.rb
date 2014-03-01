require File.dirname(__FILE__) + '/../spec_helper'

describe Certification do
  describe "complete?" do
    it "should return true for a completed cert" do
      c = Fabricate(:certification, progress: "complete")
      c.complete?.should == true
    end

    it "should return false for an in-progress cert" do
      c = Fabricate(:certification, progress: "in-progress")
      c.complete?.should == false
    end

    it "should return false for an incomplete cert" do
      c = Fabricate(:certification, progress: "incomplete")
      c.complete?.should == false
    end
  end

  describe "in-progress?" do
    it "should return false for a completed cert" do
      c = Fabricate(:certification, progress: "complete")
      c.in_progress?.should == false
    end

    it "should return true for an in-progress cert" do
      c = Fabricate(:certification, progress: "in-progress")
      c.in_progress?.should == true
    end

    it "should return false for an incomplete cert" do
      c = Fabricate(:certification, progress: "incomplete")
      c.in_progress?.should == false
    end
  end
end