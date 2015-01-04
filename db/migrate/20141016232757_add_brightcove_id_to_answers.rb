class AddBrightcoveIdToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :brightcove_id, :string
  end
end
