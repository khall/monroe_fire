class Vehicle < ActiveRecord::Base
  attr_accessible :name

  has_many :compartments
  has_many :tools, through: :compartments
end
