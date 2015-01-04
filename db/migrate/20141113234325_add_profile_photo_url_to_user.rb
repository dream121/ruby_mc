class AddProfilePhotoUrlToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :profile_photo_url
    end
  end
end
