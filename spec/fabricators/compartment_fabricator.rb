Fabricator(:compartment) do
  description { Faker::Company.bs }
  vehicle
end