class AddDefaultStateToCoursesAvailableNow < ActiveRecord::Migration
  def up
    change_column :courses, :available_now, :boolean, default: false
    change_column_null :courses, :available_now, false, false
  end

  def down
    change_column :courses, :available_now, :boolean, default: nil
    change_column_null :courses, :available_now, true
  end
end
