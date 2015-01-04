class AddIntroVideoIdToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :intro_video_id, :string
  end
end
