require 'spec_helper'

describe "runs/index" do
  it "renders list of runs" do
    runs = [Fabricate(:run, run_type: 'hazmat'),
            Fabricate(:run, run_type: 'fire'),
            Fabricate(:run, run_type: 'mutual_aid'),
            Fabricate(:run, run_type: 'rescue'),
            Fabricate(:run, run_type: 'burn_complaint'),
            Fabricate(:run, run_type: 'mvc')
           ]
    assign(:runs, runs)
    render
    rendered.should =~ /Hazmat/
    rendered.should =~ /Fire/
    rendered.should =~ /Mutual aid/
    rendered.should =~ /Rescue/
    rendered.should =~ /Burn complaint/
    rendered.should =~ /Mvc/
  end
end