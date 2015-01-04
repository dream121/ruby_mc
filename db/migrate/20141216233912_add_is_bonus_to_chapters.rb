class AddIsBonusToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :is_bonus, :boolean, default: false, null: false
  end
end
