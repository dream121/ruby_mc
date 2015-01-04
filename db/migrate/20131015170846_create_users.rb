class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :provider
      t.string :uid
      t.string :email
      t.json :info
      t.json :credentials
      t.boolean :admin

      t.timestamps
    end
  end
end
