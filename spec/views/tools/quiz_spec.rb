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
      rendered.should =~ /Percentage: 0%/
    end

    it "renders a quiz question about a tool" do
      v = Fabricate(:vehicle)
      compartments = [Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v)
      ]
      tool = Fabricate(:tool, name: 'Halligan', use: 'Skeleton key', quantity: 1, compartment: compartments[0])
      old_tool = Fabricate(:tool, name: 'Rescue chains', use: '', quantity: 1, compartment: compartments[1])
      assign(:tool, tool)
      assign(:old_tool, old_tool)
      assign(:compartments, compartments)
      assign(:results, {questions: 5, right: 3})
      flash[:alert] = "nope"
      render
      rendered.should =~ /Where is the #{tool.name} on #{tool.vehicle.name}\?/
      rendered.should =~ /Questions: 5/
      rendered.should =~ /Correct: 3/
      rendered.should =~ /Percentage: 60%/
      rendered.should =~ /img/
      rendered.should =~ /#{old_tool.compartment.image_src}/
    end

    it "doesn't display a compartment picture if answer is correct" do
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
      flash[:notice] = "yup"
      render
      rendered.should =~ /Where is the #{tool.name} on #{tool.vehicle.name}\?/
      rendered.should =~ /Questions: 5/
      rendered.should =~ /Correct: 3/
      rendered.should =~ /Percentage: 60%/
      rendered.should_not =~ /img/
      rendered.should_not =~ /#{tool.compartment.image_src}/
    end

    it "asks where 'are' instead of 'is' when the tool ends with an 's'" do
      v = Fabricate(:vehicle)
      compartments = [Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v)
      ]
      tool = Fabricate(:tool, name: 'Traffic Vests', quantity: 2, compartment: compartments[0])
      assign(:tool, tool)
      assign(:compartments, compartments)
      assign(:results, {questions: 5, right: 3})
      render
      rendered.should =~ /Where are the #{tool.name} on #{tool.vehicle.name}\?/
    end

    it "shows previous tool's compartment image on an incorrect answer" do
      v = Fabricate(:vehicle)
      compartments = [Fabricate(:compartment, vehicle: v, image_src: "cur_tool"),
                      Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v),
                      Fabricate(:compartment, vehicle: v)
      ]
      tool = Fabricate(:tool, name: 'Traffic Vests', quantity: 2, compartment: compartments[0])
      other_compartment = Fabricate(:compartment, vehicle: v, image_src: 'old_tool')
      old_tool = Fabricate(:tool, name: 'Traffic Cones', quantity: 8, compartment: other_compartment)
      assign(:tool, tool)
      assign(:old_tool, old_tool)
      assign(:compartments, compartments)
      assign(:results, {questions: 5, right: 3})
      flash[:alert] = "you got that wrong"
      render
      rendered.should =~ /Where are the #{tool.name} on #{tool.vehicle.name}\?/
      rendered.should =~ %r|src="/images/old_tool"|
    end
  end
end