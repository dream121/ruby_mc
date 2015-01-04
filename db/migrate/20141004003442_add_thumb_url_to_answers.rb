class AddThumbUrlToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :thumb_url, :string
  end
end
