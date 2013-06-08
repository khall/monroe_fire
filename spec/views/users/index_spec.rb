require 'spec_helper'

describe "users/index" do
  it "renders a list of users" do
    users = [Fabricate(:user),
             Fabricate(:user)
    ]
    assign(:users, users)
    render
    rendered.should =~ /#{users[0].email}/
    rendered.should =~ /#{users[1].email}/
  end

  it "includes a list of tool quiz percentages for users" do
    users = [Fabricate(:user)]
    Fabricate(:answer, user: users[0], question_type: "tool_quiz", correct: true)
    assign(:users, users)
    render
    rendered.should =~ /Tool Quiz Percentage/
    rendered.should =~ /100%/
  end

  it "includes a list of tool quiz correct answers for users" do
    users = [Fabricate(:user)]
    Fabricate(:answer, user: users[0], question_type: "tool_quiz", correct: true)
    assign(:users, users)
    render
    rendered.should =~ /Tools Correctly Found/
    rendered.should =~ /1/
  end
end