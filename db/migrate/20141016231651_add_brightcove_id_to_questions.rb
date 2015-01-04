class AddBrightcoveIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :brightcove_id, :string
    add_column :questions, :source_url, :string
    add_column :questions, :question_type, :string
    remove_column :questions, :external_url
  end
end
