class AddSubjectToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :subject, :string
  end
end
