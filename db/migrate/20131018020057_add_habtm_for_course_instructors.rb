class AddHabtmForCourseInstructors < ActiveRecord::Migration
  def change
    create_table :courses_instructors do |t|
      t.belongs_to :course
      t.belongs_to :instructor
    end
  end
end
