class AddEmailSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_settings, :json
    add_column :users, :privacy_settings, :json
  end
end
