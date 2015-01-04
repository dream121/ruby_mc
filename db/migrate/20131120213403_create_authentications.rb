class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.json :info
      t.json :credentials

      t.references :user

      t.timestamps
    end
  end
end
