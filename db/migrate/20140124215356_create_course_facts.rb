class CreateCourseFacts < ActiveRecord::Migration
  def change
    create_table :course_facts do |t|
      t.references :course, index: true
      t.string :kind
      t.integer :position
      t.string :icon
      t.integer :number
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
