class AddAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address, :json
  end
end
