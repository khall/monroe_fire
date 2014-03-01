class CreateCertifications < ActiveRecord::Migration
  def change
    create_table :certifications do |t|
      t.integer :user_id
      t.integer :course_id
      t.string :progress

      t.timestamps
    end
  end
end
