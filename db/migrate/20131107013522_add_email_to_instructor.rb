class AddEmailToInstructor < ActiveRecord::Migration
  def change
    add_column :instructors, :email, :string
  end
end
