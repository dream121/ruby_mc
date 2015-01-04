class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :order, index: true
      t.string :transaction_id
      t.json :response
      t.integer :amount
      t.boolean :paid
      t.boolean :refunded
      t.integer :amount_refunded

      t.timestamps
    end
  end
end
