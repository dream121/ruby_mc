class AddChapterIdToCourseComments < ActiveRecord::Migration
  def change
    add_column :course_comments, :chapter_id, :integer
  end
end
