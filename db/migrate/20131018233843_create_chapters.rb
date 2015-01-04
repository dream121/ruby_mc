class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.integer :number
      t.string :duration
      t.string :title
      t.string :brightcove_id
      t.references :course
      t.string :slug

      t.timestamps
    end
    add_index :chapters, :course_id
    add_index :chapters, :slug
  end
end
