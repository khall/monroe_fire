class Compartment < ActiveRecord::Base
  belongs_to :vehicle
  has_many :tools
end
