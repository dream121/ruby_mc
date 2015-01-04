class AddDefaultValueToQuestionAttributes < ActiveRecord::Migration
  def up
    change_column :questions, :visibility, :boolean, default: false 
  end

  def down
    change_column :questions, :visibility, :boolean, default: nil
  end
end
