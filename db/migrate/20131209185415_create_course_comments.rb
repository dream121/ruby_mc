class CreateCourseComments < ActiveRecord::Migration
  def up
    execute('CREATE EXTENSION IF NOT EXISTS ltree')
    create_table :course_comments do |t|
      t.references :course, index: true
      t.references :user, index: true
      t.string :title
      t.text :comment
      t.integer :parent_id
      t.boolean :hide
      t.integer :votes
      t.json :voters
      t.integer :position
      t.ltree :path

      t.timestamps
    end

    add_index :course_comments, :parent_id
    execute 'CREATE INDEX index_course_comments_on_path_btree ON course_comments USING btree(path)'
  end

  def down
    remove_index :course_comments, name: :index_course_comments_on_path_btree
    remove_index :course_comments, :parent_id
    remove_index :course_comments, :user_id
    remove_index :course_comments, :course_id
    drop_table :course_comments
  end
end
