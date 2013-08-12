require File.dirname(__FILE__) + '/../spec_helper'

describe VehiclesController do
  describe "index" do
    describe "when logged in" do
      before :each do
        sign_in Fabricate(:user, role: :firefighter)
      end

      it "should set @vehicles to an empty array, render 'index', return a response of 200" do
        get :index
        response.should be_success
        response.should render_template(:index)
        assigns[:vehicles].should == []
      end

      it "should set @vehicles to a non-empty array, render 'index', return a response of 200" do
        Fabricate(:vehicle)
        get :index
        response.should be_success
        response.should render_template(:index)
        assigns[:vehicles].length.should == 1
      end

      it "should set @vehicles to an array of 3 vehicles, render 'index', return a response of 200" do
        Fabricate(:vehicle)
        Fabricate(:vehicle)
        Fabricate(:vehicle)
        get :index
        response.should be_success
        response.should render_template(:index)
        assigns[:vehicles].length.should == 3
      end
    end

    describe "when logged in but not a firefighter" do
      before :each do
        sign_in Fabricate(:user, role: nil)
      end

      it "should redirect to the home page" do
        Fabricate(:vehicle)
        get :index
        response.should be_redirect
        response.should redirect_to root_path
      end
    end

    describe "when not logged in" do
      it "should redirect to the login page" do
        Fabricate(:vehicle)
        get :index
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end
    end
  end

  describe "show" do
    describe "when logged in" do
      before :each do
        sign_in Fabricate(:user, role: :firefighter)
      end

      it "should render 'show', return response of 200" do
        v = Fabricate(:vehicle)
        get :show, id: v.id
        response.should be_success
        response.should render_template(:show)
        assigns[:vehicle].should == v
      end
    end

    describe "when logged out" do
      it "should redirect to the login page" do
        v = Fabricate(:vehicle)
        get :show, id: v.id
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end
    end
  end
end