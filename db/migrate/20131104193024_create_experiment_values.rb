class CreateExperimentValues < ActiveRecord::Migration
  def change
    create_table :experiment_values do |t|
      t.string :experiment
      t.string :variation
      t.string :key
      t.string :value

      t.timestamps
    end

    add_index :experiment_values, [:experiment, :variation, :key], unique: true
  end
end
