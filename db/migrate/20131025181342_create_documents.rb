class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :kind
      t.references :documentable, polymorphic: true
      t.attachment :document

      t.timestamps
    end
  end
end
