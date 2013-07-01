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

    describe "when logged in as a firefighter" do
      it "should redirect to the home page with a flash message saying the user lacks permission to edit" do
        sign_in Fabricate(:user, role: :firefighter)
        t = Fabricate(:tool)
        get :edit, id: t.id
        response.should be_redirect
        response.should redirect_to root_path
        flash[:alert].should == "You are not authorized to access this page."
      end
    end
  end

  describe "update" do
    describe "when logged in" do
      before :each do
        sign_in Fabricate(:user, role: :webmaster)
      end

      it "should render 'edit', return response of 200" do
        t = Fabricate(:tool, name: "bad name")
        patch :update, id: t.id, tool: {name: "good name"}
        response.should be_redirect
        response.should redirect_to edit_tool_path
        assigns[:tool].name.should == "good name"
      end
    end

    describe "when logged out" do
      it "should redirect to the login page" do
        t = Fabricate(:tool)
        patch :update, id: t.id
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end
    end

    describe "when logged in as a firefighter" do
      it "should redirect to the home page with a flash message saying the user lacks permission to edit" do
        sign_in Fabricate(:user, role: :firefighter)
        t = Fabricate(:tool)
        patch :update, id: t.id
        response.should be_redirect
        response.should redirect_to root_path
        flash[:alert].should == "You are not authorized to access this page."
      end
    end
  end

  describe "quiz" do
    describe "when logged in" do
      before :each do
        sign_in Fabricate(:user, role: :firefighter)
        @vehicle = Fabricate(:vehicle)
        @compartments = [Fabricate(:compartment, vehicle: @vehicle),
                         Fabricate(:compartment, vehicle: @vehicle),
                         Fabricate(:compartment, vehicle: @vehicle),
                         Fabricate(:compartment, vehicle: @vehicle)
        ]
      end

      it "should render 'quiz', return response of 200" do
        t = Fabricate(:tool, compartment: @compartments[0])
        get :quiz
        response.should be_success
        response.should render_template(:quiz)
        assigns[:tool].name.should == t.name
        assigns[:compartments].class.should == ActiveRecord::Relation::ActiveRecord_Relation_Compartment
        assigns[:compartments].map(&:id).uniq.length.should == ANSWER_CHOICES
        @compartments.each do |c|
          assigns[:compartments].include?(c).should == true
        end
        assigns[:compartments].size.should == ANSWER_CHOICES
      end

      it "should randomly pick a tool but only return unique compartments" do
        tools = [Fabricate(:tool, compartment: @compartments[rand(@compartments.length)]),
                 Fabricate(:tool, compartment: @compartments[rand(@compartments.length)]),
                 Fabricate(:tool, compartment: @compartments[rand(@compartments.length)]),
                 Fabricate(:tool, compartment: @compartments[rand(@compartments.length)]),
                 Fabricate(:tool, compartment: @compartments[rand(@compartments.length)]),
                 Fabricate(:tool, compartment: @compartments[rand(@compartments.length)])
        ]
        get :quiz
        response.should be_success
        response.should render_template(:quiz)
        tools.map(&:name).include?(assigns[:tool].name).should ==  true
        assigns[:compartments].class.should == ActiveRecord::Relation::ActiveRecord_Relation_Compartment
        assigns[:compartments].map(&:id).uniq.length.should == ANSWER_CHOICES
        @compartments.each do |c|
          assigns[:compartments].include?(c).should == true
        end
        assigns[:compartments].size.should == ANSWER_CHOICES
      end

      it "should pick a tool and always get the compartment the tool is in" do
        100.times do
          Fabricate(:compartment, vehicle: @vehicle)
        end
        t = Fabricate(:tool, compartment: @compartments[3])
        get :quiz
        response.should be_success
        response.should render_template(:quiz)
        assigns[:tool].name.should == t.name
        assigns[:compartments].include?(assigns[:tool].compartment).should == true
        assigns[:compartments].class.should == ActiveRecord::Relation::ActiveRecord_Relation_Compartment
        assigns[:compartments].size.should == ANSWER_CHOICES
      end
    end

    describe "when logged out" do
      it "should redirect to the login page" do
        get :quiz
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end
    end
  end

  describe "quiz_answer" do
    describe "when logged in" do
      before :each do
        @user = Fabricate(:user, role: :firefighter)
        sign_in @user
      end

      it "answered correctly, should increment correct results, get a new tool, render 'quiz_answer', return response of 200" do
        t = Fabricate(:tool)
        Answer.all.count.should == 0
        patch :quiz_answer, id: t.id, answer: t.compartment.id, results: {questions: 0, correct: 0}
        response.should be_success
        response.should render_template(:quiz)
        assigns[:tool].name.should == t.name
        assigns[:results][:questions].should == 1
        assigns[:results][:right].should == 1
        flash[:notice].should == "Correct!"
        Answer.all.count.should == 1
        Answer.first.user.should == @user
        Answer.first.correct.should == true
      end

      it "answered incorrectly, should increment questions but not correct results, provide the correct answer" do
        t = Fabricate(:tool)
        c = Fabricate(:compartment)
        Answer.all.count.should == 0
        patch :quiz_answer, id: t.id, answer: c.id, results: {questions: 0, correct: 0}
        response.should be_success
        response.should render_template(:quiz)
        assigns[:tool].name.should == t.name
        assigns[:results][:questions].should == 1
        assigns[:results][:right].should == 0
        flash[:alert].should == "The #{t.name} is located in the #{t.compartment.description} on #{t.vehicle.name}"
        Answer.all.count.should == 1
        Answer.first.user.should == @user
        Answer.first.correct.should == false
      end

      it "multiple tools, should render 'quiz_answer', randomly pick a tool, return response of 200" do
        tools = [Fabricate(:tool),
                 Fabricate(:tool),
                 Fabricate(:tool),
                 Fabricate(:tool),
                 Fabricate(:tool),
                 Fabricate(:tool)
        ]
        Answer.all.count.should == 0
        patch :quiz_answer, id: tools[0].id, answer: tools[0].compartment.id, results: {questions: 0, correct: 0}
        response.should be_success
        response.should render_template(:quiz)
        tools.map(&:name).include?(assigns[:tool].name).should ==  true
        assigns[:results][:questions].should == 1
        assigns[:results][:right].should == 1
        flash[:notice].should == "Correct!"
        Answer.all.count.should == 1
        Answer.first.user.should == @user
        Answer.first.correct.should == true
      end
    end

    describe "when logged out" do
      it "should redirect to the login page" do
        patch :quiz_answer
        response.should be_redirect
        response.should redirect_to new_user_session_path
      end
    end
  end
end