class CreateCompartments < ActiveRecord::Migration
  def change
    create_table :compartments do |t|
      t.integer :vehicle_id
      t.string :description

      t.timestamps
    end
  end
end
