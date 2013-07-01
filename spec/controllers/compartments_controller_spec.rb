require File.dirname(__FILE__) + '/../spec_helper'

describe CompartmentsController do
  describe "index" do
    before :each do
      sign_in Fabricate(:user, role: :firefighter)
    end

    it "should set @compartments to an empty array, render 'index', return a response of 200" do
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns[:compartments].should == []
    end

    it "should set @compartments to a non-empty array, render 'index', return a response of 200" do
      Fabricate(:compartment)
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns[:compartments].length.should == 1
    end

    it "should set @compartments to an array of 3 tools, render 'index', return a response of 200" do
      Fabricate(:compartment)
      Fabricate(:compartment)
      Fabricate(:compartment)
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns[:compartments].length.should == 3
    end
  end

  describe "edit" do
    describe "when logged in" do
      before :each do
        sign_in Fabricate(:user, role: :webmaster)
      end

      it "should render 'edit', return response of 200" do
        c = Fabricate(:compartment)
        get :edit, id: c.id
        response.should be_success
        response.should render_template(:edit)
        assigns[:compartment].should == c
      end
    end

    describe "when logged out" do
      it "should redirect to the login page" do
        c = Fabricate(:compartment)
        get :edit, id: c.id
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end
    end
  end

  describe "update" do
    describe "when logged in" do
      before :each do
        sign_in Fabricate(:user, role: :webmaster)
      end

      it "should render 'edit', return response of 200" do
        c = Fabricate(:compartment, description: "bad description")
        patch :update, id: c.id, compartment: {description: "good description"}
        response.should be_redirect
        response.should redirect_to edit_compartment_path
        assigns[:compartment].description.should == "good description"
        flash[:notice].should == "Compartment updated"
      end
    end

    describe "when logged out" do
      it "should redirect to the login page" do
        c = Fabricate(:compartment)
        patch :update, id: c.id
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end
    end

    describe "when logged in as a firefighter" do
      it "should redirect to the home page with a flash message saying the user lacks permission to edit" do
        sign_in Fabricate(:user, role: :firefighter)
        c = Fabricate(:compartment)
        patch :update, id: c.id
        response.should be_redirect
        response.should redirect_to root_path
        flash[:alert].should == "You are not authorized to access this page."
      end
    end
  end
end