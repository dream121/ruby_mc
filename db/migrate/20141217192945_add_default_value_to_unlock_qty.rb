class AddDefaultValueToUnlockQty < ActiveRecord::Migration
  def up
    change_column :chapters, :unlock_qty, :int, default: 0, null: false
  end

  def down
    change_column :chapters, :unlock_qty, :int, default: nil
  end
end
