class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user
      t.string :display_name
      t.string :tagline
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
