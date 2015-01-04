class RemoveObsoleteCourseFields < ActiveRecord::Migration
  def up
    remove_column :courses, :role
    remove_column :courses, :skill
    remove_column :courses, :reviews
    remove_column :courses, :course_structure
    remove_column :courses, :short_description
    remove_column :courses, :invitation_statement
    remove_column :courses, :class_overview
    remove_column :courses, :lessons_introduction
    remove_column :courses, :instructor_motivation
    remove_column :courses, :welcome_statement
    remove_column :courses, :welcome_back_statement
    remove_column :courses, :total_video_duration
    remove_column :courses, :intro_video_id
    remove_column :courses, :welcome_email
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
