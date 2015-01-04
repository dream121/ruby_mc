class AddVideoDescriptionToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :video_description, :text
  end
end
