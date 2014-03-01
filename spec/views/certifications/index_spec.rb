require 'spec_helper'

describe "certifications/index" do
  it "renders list of firefighters with their certifications" do
    courses = [Fabricate(:course, name: "EMR"),
               Fabricate(:course, name: "EMT"),
               Fabricate(:course, name: "EMT-I")]
    assign(:courses, courses)
    u = Fabricate(:user, name: "John Doe")
    u.certifications = [Fabricate(:certification, user: u, course: courses[0], progress: "complete"),
                        Fabricate(:certification, user: u, course: courses[1], progress: "in-progress")]
    assign(:users, [u])
    render
    rendered.should =~ /John Doe/
    rendered.should =~ /EMT/
    rendered.should =~ /complete/
    rendered.should =~ /in-progress/
    rendered.should =~ /incomplete/
  end
end