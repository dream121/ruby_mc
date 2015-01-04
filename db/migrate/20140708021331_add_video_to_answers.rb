class AddVideoToAnswers < ActiveRecord::Migration
  def self.up
    add_attachment :answers, :video
  end

  def self.down
    remove_attachment :answers, :video
  end
end
