class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.integer :compartment_id
      t.string :name
      t.string :use
      t.integer :quantity

      t.timestamps
    end
  end
end
