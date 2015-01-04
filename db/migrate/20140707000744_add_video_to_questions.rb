class AddVideoToQuestions < ActiveRecord::Migration
  def self.up
    add_attachment :questions, :video
  end

  def self.down
    remove_attachment :questions, :video
  end
end
