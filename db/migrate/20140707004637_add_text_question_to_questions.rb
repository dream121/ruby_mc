class AddTextQuestionToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :text_question, :string
  end
end
