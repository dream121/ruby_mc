class AddProfileFieldsToInstructor < ActiveRecord::Migration
  def change
    change_table :instructors do |t|
      t.text :pitch_description
      t.text :popular_quote
      t.text :class_quote
      t.text :class_quote_attribution
      t.text :office_hours_pitch
      t.references :question
    end
  end
end
