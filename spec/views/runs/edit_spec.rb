require 'spec_helper'

describe "runs/edit" do
  it "renders form for editing a run" do
    @run = Fabricate(:run, alarm_number: 210, number_of_responders: 19, run_type: "hazmat")
    render
    rendered.should =~ /Date/
    rendered.should =~ /Alarm number/
    rendered.should =~ /Run type/
    rendered.should =~ /Number of responders/
    rendered.should =~ /Time toned out/
    rendered.should =~ /In route time/
    rendered.should =~ /Arrived time/
    rendered.should =~ /In quarters time/
    rendered.should =~ /210/
    rendered.should =~ /19/
    rendered.should =~ /hazmat/
  end
end