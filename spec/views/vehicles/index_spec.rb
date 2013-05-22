require 'spec_helper'

describe "vehicles/index" do
  it "renders list of empty vehicles" do
    vehicles = []
    assign(:vehicles, vehicles)
    render
    rendered.should =~ /No vehicles found/
  end

  it "renders list of one vehicle" do
    vehicles = [Fabricate(:vehicle, name: '1715')]
    assign(:vehicles, vehicles)
    render
    rendered.should =~ /1715/
  end

  it "renders list of several vehicles" do
    vehicles = [Fabricate(:vehicle, name: '1715'),
                Fabricate(:vehicle, name: '1711'),
                Fabricate(:vehicle, name: '1712'),
                Fabricate(:vehicle, name: '1713')
    ]
    assign(:vehicles, vehicles)
    render
    rendered.should =~ /1711/
    rendered.should =~ /1712/
    rendered.should =~ /1713/
    rendered.should =~ /1715/
  end
end