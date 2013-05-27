require 'spec_helper'

describe "tools/quiz" do
  describe "quiz for tools" do
    it "renders a quiz question about a tool, no results" do
      v = Fabricate(:vehicle)
      compartments = [Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v)
      ]
      tool = Fabricate(:tool, name: 'Halligan', use: 'Skeleton key', quantity: 1, compartment: compartments[0])
      assign(:tool, tool)
      assign(:compartments, compartments)
      assign(:results, {questions: 0, right: 0})
      render
      rendered.should =~ /Where is the #{tool.name} on #{tool.vehicle.name}\?/
      rendered.should =~ /Questions: 0/
      rendered.should =~ /Correct: 0/
      rendered.should =~ /Percentage: n\/a/
    end

    it "renders a quiz question about a tool" do
      v = Fabricate(:vehicle)
      compartments = [Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v)
      ]
      tool = Fabricate(:tool, name: 'Halligan', use: 'Skeleton key', quantity: 1, compartment: compartments[0])
      assign(:tool, tool)
      assign(:compartments, compartments)
      assign(:results, {questions: 5, right: 3})
      render
      rendered.should =~ /Where is the #{tool.name} on #{tool.vehicle.name}\?/
      rendered.should =~ /Questions: 5/
      rendered.should =~ /Correct: 3/
      rendered.should =~ /Percentage: 60/
    end
  end
end