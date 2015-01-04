class AddCourseMarketingFields < ActiveRecord::Migration
  def change
    add_column :courses, :invitation_statement, :text
    add_column :courses, :class_overview, :text
    add_column :courses, :lessons_introduction, :text
    add_column :courses, :instructor_motivation, :text
    add_column :courses, :welcome_statement, :text
    add_column :courses, :welcome_back_statement, :text
    add_column :courses, :total_video_duration, :string
    add_column :instructors, :testimonials, :text
  end
end
