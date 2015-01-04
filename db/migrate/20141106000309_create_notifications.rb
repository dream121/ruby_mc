class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :thing_type
      t.integer :thing_id
      t.integer :user_id
      t.boolean :viewed, default: false

      t.timestamps
    end
  end
end
