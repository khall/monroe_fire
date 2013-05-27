require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  describe "index" do
    describe "when logged in" do
      before :each do
        @user = Fabricate(:user, role: :firefighter)
        sign_in @user
      end

      it "should set @users to a non-empty array, render 'index', return a response of 200" do
        get :index
        response.should be_success
        response.should render_template(:index)
        assigns[:users].length.should == 1
      end

      it "should set @users to an array of 3 users, render 'index', return a response of 200" do
        Fabricate(:user)
        Fabricate(:user)
        get :index
        response.should be_success
        response.should render_template(:index)
        assigns[:users].length.should == 3
      end
    end

    describe "when not logged in" do
      it "should redirect to the login page" do
        Fabricate(:user)
        get :index
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end
    end
  end
end