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

  describe "tool_quiz_percentage" do
    it "should return 50 for 1 right 1 wrong" do
      u = Fabricate(:user, role: 'firefighter')
      Fabricate(:answer, user: u, question_type: "tool_quiz", correct: true)
      Fabricate(:answer, user: u, question_type: "tool_quiz", correct: false)
      u.tool_quiz_percentage.should == 50
    end

    it "should return 100 for 1 right answer, ignoring other user's answers" do
      u = Fabricate(:user, role: 'firefighter')
      other_user = Fabricate(:user, role: 'firefighter')
      Fabricate(:answer, user: u, question_type: "tool_quiz", correct: true)
      Fabricate(:answer, user: other_user, question_type: "tool_quiz", correct: false)
      u.tool_quiz_percentage.should == 100
    end
  end

  describe "tool_quiz_correct" do
    it "should return 2 for 2 right 1 wrong" do
      u = Fabricate(:user, role: 'firefighter')
      Fabricate(:answer, user: u, question_type: "tool_quiz", correct: true)
      Fabricate(:answer, user: u, question_type: "tool_quiz", correct: true)
      Fabricate(:answer, user: u, question_type: "tool_quiz", correct: false)
      u.tool_quiz_correct.should == 2
    end

    it "should return 1 for 1 right answer, ignoring other user's answers" do
      u = Fabricate(:user, role: 'firefighter')
      other_user = Fabricate(:user, role: 'firefighter')
      Fabricate(:answer, user: u, question_type: "tool_quiz", correct: true)
      Fabricate(:answer, user: other_user, question_type: "tool_quiz", correct: false)
      u.tool_quiz_correct.should == 1
    end
  end
end