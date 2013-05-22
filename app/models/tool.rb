class Tool < ActiveRecord::Base
  attr_accessible :compartment_id, :name, :quantity, :use

  belongs_to :compartment
  delegate :vehicle, :to => :compartment
end
