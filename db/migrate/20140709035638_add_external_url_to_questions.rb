class AddExternalUrlToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :external_url, :string
  end
end
