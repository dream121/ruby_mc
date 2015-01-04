class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :position
      t.references :product, index: true
      t.integer :related_product_id

      t.timestamps
    end

    add_index :recommendations, :related_product_id
  end
end
