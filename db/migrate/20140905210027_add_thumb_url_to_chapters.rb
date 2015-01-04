class AddThumbUrlToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :thumb_url, :string
  end
end
