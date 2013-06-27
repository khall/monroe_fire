class Vehicle < ActiveRecord::Base
  has_many :compartments
  has_many :tools, through: :compartments
end
