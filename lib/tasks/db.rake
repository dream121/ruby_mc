namespace :db do
  desc "Load a small, representative set of data so that the application can start in an use state (for development)."
  task sample_data: :environment do
    sample_data = File.join(Rails.root, 'db', 'sample_data.rb')
    load(sample_data) if sample_data
  end

  task migrate_authentications: :environment do
    ['facebook', 'developer'].each do |provider|
      User.where(provider: provider).each do |u|
        if u.authentications.detect {|a| a.provider == provider}
          puts ['authentication exists', u.email].inspect
        else
          a = u.authentications.create! do |authorization|
            authorization.provider = u.provider
            authorization.uid = u.uid
            authorization.info = u.info
            authorization.credentials = u.credentials
          end
          puts [a.provider, a.uid, u.email].inspect
        end
      end
    end
  end

  task migrate_permissions: :environment do
    User.all.each do |u|
      u.permissions = {
        'admin' => u[:admin],
        'comments' => true
      }
      u.save!
    end
  end
end
