class RemoveOrderFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :order, :integer
  end
end
