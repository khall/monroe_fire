require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  describe "firefighter?" do
    it "should return true for firefighter user" do
      u = Fabricate(:user, role: 'firefighter')
      u.firefighter?.should == true
    end

    it "should return false for non-firefighter user" do
      u = Fabricate(:user, role: nil)
      u.firefighter?.should == false
    end
  end

  describe "webmaster?" do
    it "should return true for webmaster user" do
      u = Fabricate(:user, role: 'webmaster')
      u.webmaster?.should == true
    end

    it "should return false for non-webmaster user" do
      u = Fabricate(:user, role: nil)
      u.webmaster?.should == false
    end
  end

  describe "chief?" do
    it "should return true for chief user" do
      u = Fabricate(:user, role: 'chief')
      u.chief?.should == true
    end

    it "should return false for non-chief user" do
      u = Fabricate(:user, role: nil)
      u.chief?.should == false
    end
  end
end