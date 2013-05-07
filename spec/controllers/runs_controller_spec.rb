require File.dirname(__FILE__) + '/../spec_helper'

describe RunsController do
  describe "index" do
    it "should set @runs, render 'index', return a response of 200" do
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns[:runs].should_not == nil
    end
  end

  describe "new" do
    it "should render 'new', return response of 200" do
      sign_in Fabricate(:user, role: :chief)
      get :new
      response.should be_success
      response.should render_template(:new)
    end

    it "should redirect to root" do
      get :new
      response.should be_redirect
      response.should redirect_to new_user_session_path
    end
  end

  describe "create" do
    before(:each) do
      sign_in Fabricate(:user, role: :chief)
    end

    it "should render 'new', return response of 200, create a new run" do
      new_run_str = "2/13/13	25				1			0:57	5	0:05	0:09	16:21	16:26	16:30	17:18"

      Run.all.length.should == 0
      post :create, excel_str: new_run_str
      run = Run.all
      run.length.should == 1
      run[0].alarm_number.should == 25
      run[0].date.should == DateTime.parse('2013/02/13 16:21:00')

      response.should be_success
      response.should render_template(:new)
      flash[:notice].should == "Run added"
    end

    it "should not create a new run since the run number has been used" do
      new_run_str = "2/13/13	25				1			0:57	5	0:05	0:09	16:21	16:26	16:30	17:18"
      existing_run = Fabricate(:run, alarm_number: 25)

      runs = Run.all
      runs.length.should == 1
      runs[0].date.should == existing_run.date
      post :create, excel_str: new_run_str
      runs = Run.all
      runs.length.should == 1
      runs[0].date.should == existing_run.date

      response.should be_success
      response.should render_template(:new)
      flash[:error].should == "Run was not added"
    end

    it "should not create a new run since the string is missing a field" do
      new_run_str = "2/13/13	25				1			0:57	5	0:05	0:09	16:21	16:26	16:30"

      Run.all.length.should == 0
      post :create, excel_str: new_run_str
      Run.all.length.should == 0

      response.should be_success
      response.should render_template(:new)
      flash[:error].should == "Run was not added. You seem to be missing some data. There needs to be 11 pieces of data."
    end

    it "should not create a new run since there is no type" do
      new_run_str = "2/13/13	25			Z	 			0:57	5	0:05	0:09	16:21	16:26	16:30	17:18"

      Run.all.length.should == 0
      post :create, excel_str: new_run_str
      Run.all.length.should == 0

      response.should be_success
      response.should render_template(:new)
      flash[:error].should == "Couldn't match the type of run with string"
    end

    it "should create a new run that deals with the day changing" do
      new_run_str = "2/13/13	25				1			0:57	5	0:05	0:09	23:55	00:00	00:05	01:00"

      Run.all.length.should == 0
      post :create, excel_str: new_run_str
      runs = Run.all
      runs.length.should == 1
      runs[0].in_route_time.should == DateTime.parse("2013/02/14 00:00:00")
      runs[0].arrived_time.should == DateTime.parse("2013/02/14 00:05:00")
      runs[0].in_quarters_time.should == DateTime.parse("2013/02/14 01:00:00")

      response.should be_success
      response.should render_template(:new)
      flash[:notice].should == "Run added"
      flash[:error].should == nil
    end

    it "should deal with a four digit year" do
      new_run_str = "4/1/2013	47				1			0:20	8	0:04	0:11	6:28	6:32	6:39	6:48"

      Run.all.length.should == 0
      post :create, excel_str: new_run_str
      run = Run.all
      run.length.should == 1
      run[0].alarm_number.should == 47
      run[0].date.should == DateTime.parse('2013/04/01 06:28:00')

      response.should be_success
      response.should render_template(:new)
      flash[:notice].should == "Run added"
    end


    it "should not add a run that's in the past, but should provide a useful error message" do
      new_run_str = "5/3/2012	69		1					0:30	5	0:02	0:07	15:00	15:02	15:07	15:30"

      Run.all.length.should == 0
      post :create, excel_str: new_run_str
      run = Run.all
      run.length.should == 0

      response.should be_success
      response.should render_template(:new)
      flash[:notice].should == "The date for this run appears to have a date that is likely incorrect, so no run was created."
    end
  end
end