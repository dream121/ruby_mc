class AddTweetTextToCourseDetails < ActiveRecord::Migration
  def change
  	add_column :course_details, :tweet_text, :string
  end
end
