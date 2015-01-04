class AddCourseStructure < ActiveRecord::Migration
  def change
    add_column :courses, :course_structure, :text
  end
end
