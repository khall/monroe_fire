require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "signup" do
    it "should set redirect to home" do
      get :signup
      response.should be_redirect
    end

    it "should set @runs, render 'new', return a response of 200" do
      sign_in Fabricate(:user, role: :webmaster)
      get :signup
      response.should be_success
      response.should render_template(:new)
    end
  end
end