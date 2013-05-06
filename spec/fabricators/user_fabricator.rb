Fabricator(:user) do
  email { Faker::Internet.email }
  password { "wuddupall" }
  role { [nil, :firefighter, :chief, :webmaster].sample }
end