class AddFilepickerColumnsToInstructors < ActiveRecord::Migration
  def change
    change_table :instructors do |t|
      t.string :hero_url
      t.string :popular_quote_logo_url
    end
  end
end
