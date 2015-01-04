class AddWelcomeEmailToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :welcome_email, :text
  end
end
