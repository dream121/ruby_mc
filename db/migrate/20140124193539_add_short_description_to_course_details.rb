class AddShortDescriptionToCourseDetails < ActiveRecord::Migration
  def change
    add_column :course_details, :short_description, :text
  end
end
