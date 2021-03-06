class Run < ActiveRecord::Base
  validates_presence_of :date, :alarm_number, :run_type, :number_of_responders, :time_out, :in_route_time, :arrived_time, :in_quarters_time
  validate :unique_alarm_number_in_year, on: :create

  scope :alarm_number, -> (alarm_number) { where("alarm_number = #{alarm_number}") }
  scope :this_year, -> { where("date >= '#{Time.now.beginning_of_year}' AND date <= '#{Time.now.end_of_year}'").order("alarm_number ASC") }
  scope :year, -> (year) { where("date >= '#{Time.parse("#{year}/01/01 00:00:00")}' AND date < '#{Time.parse("#{year.to_i + 1}/01/01 00:00:00")}'").order("alarm_number ASC")}
  scope :older_than, -> (num_days) { where("date <= '#{Time.now - num_days.days}'")}
  scope :newer_than, -> (num_days) { where("date >= '#{Time.now - num_days.days}'")}

  def total_time_out
    ((in_quarters_time - date) / 60).to_i
  end

  def minutes_in_route
    ((in_route_time - date) / 60).to_i
  end

  def minutes_to_scene
    ((arrived_time - date) / 60).to_i
  end

  def self.run_types
    Run.select('run_type').map(&:run_type).uniq
  end

  private

  def unique_alarm_number_in_year
    if Run.year(self.date.strftime('%y')).alarm_number(self.alarm_number).length == 1
      errors.add(:alarm_number, "can't appear twice in the same year")
    end
  end
end