Fabricator(:certification) do
  user
  course
  progress { ["complete", "in-progress", "incomplete"][rand(3)] }
end