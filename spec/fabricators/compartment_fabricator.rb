Fabricator(:compartment) do
  description { Faker::Company.bs }
  vehicle
  image_src { Faker::Internet.url }
end