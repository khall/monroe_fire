class Compartment < ActiveRecord::Base
  attr_accessible :description, :vehicle_id

  belongs_to :vehicle
  has_many :tools
end
