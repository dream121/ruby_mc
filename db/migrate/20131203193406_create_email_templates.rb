class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.string :from
      t.string :subject
      t.text :body
      t.references :course, index: true
      t.string :kind

      t.timestamps
    end
  end
end
