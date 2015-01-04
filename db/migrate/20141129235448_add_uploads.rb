class AddUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.references :uploadable, polymorphic: true

      t.string :url
      t.string :kind
      t.string :key
      t.string :mimetype

      t.timestamps
    end
  end
end
