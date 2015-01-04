class AddOrderFieldsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :order, :integer
    add_column :questions, :visibility, :boolean
  end
end
