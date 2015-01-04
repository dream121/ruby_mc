class AddRoleAndSkillToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :role, :string
    add_column :courses, :skill, :string
  end
end
