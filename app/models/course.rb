class Course < ActiveRecord::Base
  has_many :certifications
  has_many :users, through: :certifications
end
