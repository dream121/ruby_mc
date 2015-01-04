class AddAuthenticationToIdentity < ActiveRecord::Migration
  def change
    add_reference :identities, :authentication, index: true
  end
end
