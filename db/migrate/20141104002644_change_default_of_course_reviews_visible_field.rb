class ChangeDefaultOfCourseReviewsVisibleField < ActiveRecord::Migration
  def change
    change_column :course_reviews, :visible, :boolean, default: true
  end
end
