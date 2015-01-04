class AddUserToInstructor < ActiveRecord::Migration
  def change
    add_reference :instructors, :user, index: true
  end
end
