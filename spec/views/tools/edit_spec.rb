require 'spec_helper'

describe "tools/edit" do
  describe "edit a tool" do
    it "renders edit for a tool" do
      tool = Fabricate(:tool, name: 'Halligan', use: 'Skeleton key', quantity: 42)
      assign(:tool, tool)
      render
      rendered.should =~ /#{tool.name}/
      rendered.should =~ /#{tool.use}/
      rendered.should =~ /#{tool.quantity}/
      rendered.should =~ /Update/
    end
  end
end