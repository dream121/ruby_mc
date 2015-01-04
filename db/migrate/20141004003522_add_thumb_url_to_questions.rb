class AddThumbUrlToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :thumb_url, :string
  end
end
