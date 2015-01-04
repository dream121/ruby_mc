class RemoveColumnIsLockedFromChapters < ActiveRecord::Migration
  def change
    remove_column :chapters, :is_locked
  end
end
