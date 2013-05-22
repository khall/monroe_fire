Fabricator(:vehicle) do
  name { "17" + (rand(30) + 10).to_s }
end