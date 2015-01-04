class AddImageUrlToCourseComments < ActiveRecord::Migration
  def change
    add_column :course_comments, :image_url, :string
  end
end
