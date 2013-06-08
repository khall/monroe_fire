class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :user_id
      t.string :question_type
      t.integer :question_id
      t.boolean :correct

      t.timestamps
    end
  end
end
