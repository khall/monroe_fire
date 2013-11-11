require File.dirname(__FILE__) + '/../spec_helper'

describe RunsController do
  describe "index" do
    it "should set @runs, render 'index', return a response of 200" do
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns[:runs].should_not == nil
      assigns[:years].should == []
    end

    it "should set @years as an array of integers" do
      Fabricate(:run, date: DateTime.parse('2014/01/01 00:00:00'))
      Time.stub(:now).and_return(Time.parse('2014/01/10 16:00:00'))
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns[:runs].should_not == nil
      assigns[:years].should == [2014]
      assigns[:num_old_runs].should == 0
      assigns[:num_new_runs].should == 1
    end

    it "should set @years as an array of integers" do
      Fabricate(:run, date: DateTime.parse('2013/01/01 00:00:00'))
      Fabricate(:run, date: DateTime.parse('2013/02/01 00:00:00'))
      Fabricate(:run, date: DateTime.parse('2014/01/01 00:00:00'))
      Fabricate(:run, date: DateTime.parse('2014/02/01 00:00:00'))
      Time.stub(:now).and_return(Time.parse('2014/02/10 16:00:00'))
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns[:runs].should_not == nil
      assigns[:years].should == [2013, 2014]
      assigns[:num_old_runs].should == 1
      assigns[:num_new_runs].should == 1
    end

    it "filters runs on year" do
      Fabricate(:run, date: DateTime.parse('2013/02/01 00:00:00'))
      Fabricate(:run, date: DateTime.parse('2014/02/01 00:00:00'))
      run1 = Fabricate(:run, date: DateTime.parse('2012/02/01 00:00:00'))
      run2 = Fabricate(:run, date: DateTime.parse('2012/03/01 00:00:00'))
      Time.stub(:now).and_return(Time.parse('2014/02/10 16:00:00'))
      get :index, :year_filter => 2012
      response.should be_success
      response.should render_template(:index)
      assigns[:runs].should == [run1, run2]
      assigns[:years].should == [2012, 2013, 2014]
      assigns[:num_old_runs].should_not == 3
      assigns[:num_new_runs].should_not == 1
    end

    it "filters runs on year with no runs" do
      Fabricate(:run, date: DateTime.parse('2013/02/01 00:00:00'))
      Fabricate(:run, date: DateTime.parse('2014/02/01 00:00:00'))
      Fabricate(:run, date: DateTime.parse('2012/02/01 00:00:00'))
      get :index, :year_filter => 2011
      response.should be_success
      response.should render_template(:index)
      assigns[:runs].should == []
      assigns[:years].should == [2012, 2013, 2014]
    end

    it "tries to filter on a string that isn't a year" do
      Fabricate(:run, date: DateTime.parse('2014/02/01 00:00:00'))
      Fabricate(:run, date: DateTime.parse('2013/02/01 00:00:00'))
      get :index, :year_filter => 'hello'
      response.should be_success
      response.should render_template(:index)
      assigns[:runs].should == []
      assigns[:years].should == [2013, 2014]
    end
  end

  describe "new" do
    it "allows chief to access page, renders 'new', returns response of 200" do
      sign_in Fabricate(:user, role: :chief)
      get :new
      response.should be_success
      response.should render_template(:new)
    end

    it "redirects to root for a non-user" do
      get :new
      response.should be_redirect
      response.should redirect_to new_user_session_path
    end

    it "allows webmaster to access new run page" do
      sign_in Fabricate(:user, role: :webmaster)
      get :new
      response.should be_success
      response.should render_template(:new)
    end

    it "does not allow a firefighter to access new run page" do
      sign_in Fabricate(:user, role: :firefighter)
      get :new
      response.should be_redirect
      response.should redirect_to root_path
    end

    it "does not allow a user without a role to access new run page" do
      sign_in Fabricate(:user, role: nil)
      get :new
      response.should be_redirect
      response.should redirect_to root_path
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

    it "should not create a new run since the run number has been used in the same year" do
      new_run_str = "2/13/13	29				1			0:57	5	0:05	0:09	16:21	16:26	16:30	17:18"
      existing_run = Fabricate(:run, alarm_number: 29, date: DateTime.parse('2013/05/05 17:00:00'))

      runs = Run.all
      runs.length.should == 1
      runs[0].date.should == existing_run.date
      post :create, excel_str: new_run_str
      runs = Run.all
      runs.length.should == 1
      runs[0].date.should == existing_run.date

      response.should be_success
      response.should render_template(:new)
      flash[:alert].should == "Run was not added"
    end

    it "should create a new run since the run number has been used, but in a different year" do
      new_run_str = "2/13/13	25				1			0:57	5	0:05	0:09	16:21	16:26	16:30	17:18"
      existing_run = Fabricate(:run, alarm_number: 25, date: DateTime.parse('2012/05/05 17:00:00'))

      runs = Run.all
      runs.length.should == 1
      runs[0].date.should == existing_run.date
      post :create, excel_str: new_run_str
      runs = Run.all
      runs.length.should == 2
      runs[0].date.should == existing_run.date
      runs[1].date.should == DateTime.parse('2013/02/13 16:21:00')

      response.should be_success
      response.should render_template(:new)
      flash[:notice].should == "Run added"
    end

    it "should not create a new run since the string is missing a field" do
      new_run_str = "2/13/13	25				1			0:57	5	0:05	0:09	16:21	16:26	16:30"

      Run.all.length.should == 0
      post :create, excel_str: new_run_str
      Run.all.length.should == 0

      response.should be_success
      response.should render_template(:new)
      flash[:alert].should == "Run was not added. You seem to be missing some data. There needs to be 11 pieces of data."
    end

    it "should not create a new run since there is no type" do
      new_run_str = "2/13/13	25			Z	 			0:57	5	0:05	0:09	16:21	16:26	16:30	17:18"

      Run.all.length.should == 0
      post :create, excel_str: new_run_str
      Run.all.length.should == 0

      response.should be_success
      response.should render_template(:new)
      flash[:alert].should == "Couldn't match the type of run with string"
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
      flash[:alert].should == nil
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
  end
end