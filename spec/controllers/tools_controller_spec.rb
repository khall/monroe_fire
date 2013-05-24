require File.dirname(__FILE__) + '/../spec_helper'

describe ToolsController do
  describe "index" do
    describe "when logged in" do
      before :each do
        sign_in Fabricate(:user, role: :firefighter)
      end

      it "should set @tools to an empty array, render 'index', return a response of 200" do
        get :index
        response.should be_success
        response.should render_template(:index)
        assigns[:tools].should == []
      end

      it "should set @tools to a non-empty array, render 'index', return a response of 200" do
        Fabricate(:tool)
        get :index
        response.should be_success
        response.should render_template(:index)
        assigns[:tools].length.should == 1
      end

      it "should set @tools to an array of 3 tools, render 'index', return a response of 200" do
        Fabricate(:tool)
        Fabricate(:tool)
        Fabricate(:tool)
        get :index
        response.should be_success
        response.should render_template(:index)
        assigns[:tools].length.should == 3
      end
    end

    describe "when not logged in" do
      it "should redirect to the login page" do
        Fabricate(:tool)
        get :index
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end

      it "should redirect to the login page when searching for a tool" do
        Fabricate(:tool)
        get :index, search: "Tool"
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end
    end

    describe "searching for tool" do
      before :each do
        sign_in Fabricate(:user, role: :firefighter)
      end

      it "should not find any tools" do
        Fabricate(:tool, name: "Halligan")
        get :index, search: "Hockey stick"
        response.should be_success
        response.should render_template(:index)
        assigns[:tools].length.should == 0
      end

      it "should find one tool" do
        Fabricate(:tool, name: "Halligan")
        Fabricate(:tool, name: "SCBA")
        Fabricate(:tool, name: "Backboard")
        get :index, search: "SCBA"
        response.should be_success
        response.should render_template(:index)
        assigns[:tools].length.should == 1
      end

      it "should find one tool, ignoring lower case search when tool is upper case" do
        Fabricate(:tool, name: "Halligan")
        Fabricate(:tool, name: "SCBA")
        Fabricate(:tool, name: "Backboard")
        get :index, search: "scba"
        response.should be_success
        response.should render_template(:index)
        assigns[:tools].length.should == 1
      end

      it "should find one tool, ignoring upper case search when tool is lower case" do
        Fabricate(:tool, name: "Halligan")
        Fabricate(:tool, name: "scba")
        Fabricate(:tool, name: "Backboard")
        get :index, search: "SCBA"
        response.should be_success
        response.should render_template(:index)
        assigns[:tools].length.should == 1
      end

      it "should find two tools" do
        Fabricate(:tool, name: "Halligan")
        Fabricate(:tool, name: "SCBA")
        Fabricate(:tool, name: "SCBA")
        Fabricate(:tool, name: "Backboard")
        get :index, search: "SCBA"
        response.should be_success
        response.should render_template(:index)
        assigns[:tools].length.should == 2
      end
    end
  end

  describe "show" do
    describe "when logged in" do
      before :each do
        sign_in Fabricate(:user, role: :firefighter)
      end

      it "should render 'show', return response of 200" do
        t = Fabricate(:tool)
        get :show, id: t.id
        response.should be_success
        response.should render_template(:show)
        assigns[:tool].should == t
      end
    end

    describe "when logged out" do
      it "should redirect to the login page" do
        t = Fabricate(:tool)
        get :show, id: t.id
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end
    end
  end

  describe "edit" do
    describe "when logged in" do
      before :each do
        sign_in Fabricate(:user, role: :webmaster)
      end

      it "should render 'edit', return response of 200" do
        t = Fabricate(:tool)
        get :edit, id: t.id
        response.should be_success
        response.should render_template(:edit)
        assigns[:tool].should == t
      end
    end

    describe "when logged out" do
      it "should redirect to the login page" do
        t = Fabricate(:tool)
        get :edit, id: t.id
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end
    end
  end
end