require 'spec_helper'

describe "vehicles/show" do
  it "renders one vehicle with one compartment with one tool with quantity 3" do
    v = Fabricate(:vehicle, name: '1715')
    c = Fabricate(:compartment, description: "Driver's side front-most", vehicle: v)
    Fabricate(:tool, name: 'Bullet-proof vest', use: 'Not getting dead', quantity: 3, compartment: c)
    assign(:vehicle, v)
    render
    rendered.should =~ /1715/
    rendered.should =~ /Driver's side front-most/
    rendered.should =~ /Bullet-proof vest/
    rendered.should =~ /Not getting dead/
    rendered.should =~ /3/
  end
end