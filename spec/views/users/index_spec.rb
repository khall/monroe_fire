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
end