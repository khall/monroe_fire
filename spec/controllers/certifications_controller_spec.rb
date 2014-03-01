require File.dirname(__FILE__) + '/../spec_helper'

describe CertificationsController do
  describe "index" do
    it "should set @users to an empty array, render 'index', return a response of 200" do
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns[:users].should == []
    end

    it "should set @users to an array of all users, render 'index', return a response of 200" do
      u1 = Fabricate(:user, role: 'firefighter')
      u2 = Fabricate(:user, role: 'firefighter')
      course1 = Fabricate(:course)
      course2 = Fabricate(:course)
      c1 = Fabricate(:certification, user: u1, course: course1)
      c2 = Fabricate(:certification, user: u2, course: course2)
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns[:users].include?(u1).should == true
      assigns[:users].include?(u2).should == true
      # this to_a below seems like a rails bug, because without it include? returns "1"
      assigns[:users].detect{|u| u == u1}.certifications.to_a.include?(c1).should == true
      assigns[:users].detect{|u| u == u2}.certifications.to_a.include?(c2).should == true
    end
  end
end