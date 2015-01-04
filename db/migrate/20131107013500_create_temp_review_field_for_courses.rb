class CreateTempReviewFieldForCourses < ActiveRecord::Migration
  def change
    add_column :courses, :reviews, :text
  end
end
