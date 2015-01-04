class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.text :short_description
      t.text :long_description
      t.string :slug
      t.integer :price
      t.date :start_date

      t.timestamps
    end

    add_index :courses, :slug, unique: true
  end
end
