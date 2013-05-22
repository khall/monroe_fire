require 'spec_helper'

describe "tools/index" do
  describe "searching for tool" do
    it "renders list of searched for tool" do
      tool = Fabricate(:tool, name: 'Halligan', use: 'Skeleton key', quantity: 1)
      assign(:tools, [tool])
      render
      rendered.should =~ /Halligan/
      rendered.should =~ /#{tool.compartment.description}/
      rendered.should =~ /#{tool.compartment.vehicle.name}/
      #rendered.should =~ /Skeleton key/
      rendered.should =~ /Search for tool/
    end
  end
end