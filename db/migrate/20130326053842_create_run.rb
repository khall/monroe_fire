class CreateRun < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.datetime :date
      t.integer :alarm_number
      t.string :run_type
      t.integer :number_of_responders
      t.integer :time_out
      t.datetime :in_route_time
      t.datetime :arrived_time
      t.datetime :in_quarters_time

      t.timestamps
    end
  end
end
