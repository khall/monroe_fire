require 'spec_helper'

describe "compartments/index" do
  describe "listing compartments" do
    it "renders list of compartments" do
      compartments = [Fabricate(:compartment),
                      Fabricate(:compartment),
                      Fabricate(:compartment)]
      assign(:compartments, compartments)
      render
      rendered.should =~ /#{compartments[0].description}/
      rendered.should =~ /#{compartments[1].description}/
      rendered.should =~ /#{compartments[2].description}/
    end
  end
end