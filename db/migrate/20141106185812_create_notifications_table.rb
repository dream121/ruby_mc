class CreateNotificationsTable < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.boolean :viewed, default: false
      t.references :notifiable, polymorphic: true

      t.timestamps
    end
  end
end
