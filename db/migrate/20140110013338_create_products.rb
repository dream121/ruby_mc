class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.string :kind
      t.references :course, index: true

      t.timestamps
    end
  end
end
