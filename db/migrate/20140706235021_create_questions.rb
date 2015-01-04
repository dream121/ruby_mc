class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :course_id

      t.timestamps
    end
  end
end
