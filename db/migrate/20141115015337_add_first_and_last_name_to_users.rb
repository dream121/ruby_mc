class AddFirstAndLastNameToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string :first_name
      t.string :last_name
    end

    User.find_each do |u|
      name = u.name.to_s.split(' ')

      u.update_columns first_name: name[0]

      if name.length > 1
        u.update_columns last_name: name[1]
      end
    end
  end

  def down
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
