class CreateOrderProducts < ActiveRecord::Migration
  def change
    create_table :order_products do |t|
      t.integer :price
      t.integer :qty
      t.references :order, index: true
      t.references :product, index: true

      t.timestamps
    end
  end
end
