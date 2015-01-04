class CreateCartProducts < ActiveRecord::Migration
  def change
    create_table :cart_products do |t|
      t.integer :price
      t.integer :qty
      t.references :cart, index: true
      t.references :product, index: true

      t.timestamps
    end
  end
end
