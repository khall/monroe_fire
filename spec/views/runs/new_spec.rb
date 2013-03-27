require 'spec_helper'

describe "runs/new" do
  it "renders simple form for adding a new run" do
    column_order = "Date, Alarm #, Burn compliants, Fire, Rescue, MVC, HazMat, Mutual aid, Total time out, # of personnel responding, Response time in route, Response time to scene, Alarm time, In route, 1st arrived, In quarters"
    render
    rendered.should =~ /Paste Excel row into text field below and click "Add Run"/
    rendered.should =~ /Excel columns should be in the following order: #{column_order}/
    rendered.should =~ /Excel row string/
  end
end