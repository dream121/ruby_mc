class AddOrderToUserCourse < ActiveRecord::Migration
  def change
    add_reference :user_courses, :order, index: true
  end
end
