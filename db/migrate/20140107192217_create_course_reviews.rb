class CreateCourseReviews < ActiveRecord::Migration
  def change
    create_table :course_reviews do |t|
      t.text :review
      t.integer :rating
      t.string :name
      t.string :location
      t.references :course, index: true
      t.references :user, index: true
      t.boolean :visible, default: false
      t.boolean :featured, default: false
      t.integer :position

      t.timestamps
    end
  end
end
