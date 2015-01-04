class AddFeaturedReviewToCourseDetails < ActiveRecord::Migration
  def change
    add_column :course_details, :featured_review, :text
  end
end
