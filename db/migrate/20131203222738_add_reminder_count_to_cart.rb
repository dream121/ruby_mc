class AddReminderCountToCart < ActiveRecord::Migration
  def change
    add_column :carts, :reminder_count, :integer
  end
end
