class AddFbHeadlineAndFbDescriptionAndFbLinkToHomePages < ActiveRecord::Migration
  def change
  	add_column :home_pages, :fb_headline, :text
  	add_column :home_pages, :fb_description, :text
  	add_column :home_pages, :fb_link, :string
  end
end
