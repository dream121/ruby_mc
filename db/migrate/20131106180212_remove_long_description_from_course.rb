class RemoveLongDescriptionFromCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :long_description
  end
end
