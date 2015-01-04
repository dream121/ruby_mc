class AddReviewAverageDisplayToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :review_average_display, :decimal, precision: 3, scale: 2
    add_column :courses, :student_count_display, :int
  end
end
