class CreateCourseDetails < ActiveRecord::Migration
  def change
    create_table :course_details do |t|
      t.references :course, index: true
      t.text :headline
      t.string :role
      t.string :skill
      t.text :overview
      t.text :invitation_statement
      t.text :lessons_introduction
      t.text :instructor_motivation
      t.text :welcome_statement
      t.text :welcome_back_statement
      t.string :total_video_duration
      t.string :intro_video_id

      t.timestamps
    end
  end
end
