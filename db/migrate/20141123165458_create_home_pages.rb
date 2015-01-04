class CreateHomePages < ActiveRecord::Migration
  def change
    create_table :home_pages do |t|
      t.text :tweet_text
      t.timestamps
    end
  end
end
