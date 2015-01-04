class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :redemptions
      t.integer :max_redemptions
      t.integer :price
      t.references :course, index: true
      t.datetime :expires_at

      t.timestamps
    end
  end
end
