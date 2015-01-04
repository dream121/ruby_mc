class AddAvailableNowToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :available_now, :boolean
  end
end
