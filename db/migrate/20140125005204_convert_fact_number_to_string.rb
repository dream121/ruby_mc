class ConvertFactNumberToString < ActiveRecord::Migration
  def up
    change_column :course_facts, :number, :string
  end

  def down
    change_column :course_facts, :number, :integer
  end
end
