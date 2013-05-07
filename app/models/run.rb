class Run < ActiveRecord::Base
  attr_accessible :date, :alarm_number, :run_type, :number_of_responders, :time_out, :in_route_time, :arrived_time, :in_quarters_time
  validates_presence_of :date, :alarm_number, :run_type, :number_of_responders, :time_out, :in_route_time, :arrived_time, :in_quarters_time
  validate :unique_alarm_number_in_year

  scope :alarm_number, lambda{|alarm_number| { conditions: "alarm_number = #{alarm_number}"}}
  scope :this_year, conditions: "date >= '#{Time.now.beginning_of_year}' AND date <= '#{Time.now.end_of_year}'", order: "alarm_number ASC"
  scope :year, lambda{|year| { conditions: "date >= '#{Time.parse("#{year}/01/01 00:00:00")}' AND date < '#{Time.parse("#{year.to_i + 1}/01/01 00:00:00")}'", order: "alarm_number ASC"}}

  def total_time_out
    ((in_quarters_time - date) / 60).to_i
  end

  def minutes_in_route
    ((in_route_time - date) / 60).to_i
  end

  def minutes_to_scene
    ((arrived_time - date) / 60).to_i
  end

  private

  def unique_alarm_number_in_year
    if Run.year(self.date.strftime('%y')).alarm_number(self.alarm_number).length == 1
      errors.add(:alarm_number, "can't appear twice in the same year")
    end
  end
end