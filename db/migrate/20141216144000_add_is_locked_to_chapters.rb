class AddIsLockedToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :is_locked, :boolean, default: false, null: false
    add_column :chapters, :unlock_qty, :int, default: 0
    add_column :chapters, :position, :int
  end
end
