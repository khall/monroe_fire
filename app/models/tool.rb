class Tool < ActiveRecord::Base
  belongs_to :compartment
  delegate :vehicle, :to => :compartment
end
