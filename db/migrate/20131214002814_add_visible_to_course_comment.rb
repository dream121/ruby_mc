class AddVisibleToCourseComment < ActiveRecord::Migration
  def change
    add_column :course_comments, :visible, :boolean
  end
end
