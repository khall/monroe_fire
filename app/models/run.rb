class Run < ActiveRecord::Base
  validates_presence_of :date, :alarm_number, :run_type, :number_of_responders, :time_out, :in_route_time, :arrived_time, :in_quarters_time
  validates :alarm_number, uniqueness: true

  scope :this_year, conditions: "date >= '#{Time.now.beginning_of_year}' AND date <= '#{Time.now.end_of_year}'", order: "alarm_number ASC"

  def total_time_out
    ((in_quarters_time - date) / 60).to_i
  end

  def minutes_in_route
    ((in_route_time - date) / 60).to_i
  end

  def minutes_to_scene
    ((arrived_time - date) / 60).to_i
  end
end