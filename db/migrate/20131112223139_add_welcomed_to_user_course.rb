class AddWelcomedToUserCourse < ActiveRecord::Migration
  def change
    add_column :user_courses, :welcomed, :boolean
    add_index :user_courses, :welcomed
  end
end
