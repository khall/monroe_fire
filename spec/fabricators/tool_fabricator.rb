Fabricator(:tool) do
  compartment
  name { Faker::Company.name }
  use { Faker::Company.catch_phrase }
  quantity { rand(10) }
end