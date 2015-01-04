class AddResponseToCart < ActiveRecord::Migration
  def change
    add_column :carts, :response, :json
  end
end
