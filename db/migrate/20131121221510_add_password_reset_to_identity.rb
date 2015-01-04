class AddPasswordResetToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :password_reset_token, :string
    add_column :identities, :password_reset_sent_at, :datetime
    add_index :identities, :password_reset_token
  end
end
