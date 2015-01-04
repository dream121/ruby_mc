class CreateInstructors < ActiveRecord::Migration
  def change
    create_table :instructors do |t|
      t.string :name
      t.text :short_bio
      t.text :long_bio
      t.string :slug

      t.timestamps
    end
    add_index :instructors, :slug, unique: true
  end
end
