require 'spec_helper'

describe "compartments/edit" do
  describe "edit a compartment" do
    it "renders edit for a compartment" do
      compartment = Fabricate(:compartment, description: "Drivers side rear")
      tool = Fabricate(:tool, compartment: compartment)
      assign(:compartment, compartment)
      render
      rendered.should =~ /Return to compartments list/
      rendered.should =~ /#{tool.name}/
      rendered.should =~ /#{compartment.description}/
      rendered.should =~ /Update/
    end
  end
end