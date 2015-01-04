namespace :admin do
  namespace :users do

    # heroku run rake admin:users:facebook_to_identity['user@example.com']
    desc 'Convert a facebook authentication to an email authentication'
    task :facebook_to_identity, [:email] => [:environment] do |t, args|
      user = User.find_by email: args.email
      raise 'User not found' unless user
      AuthenticationConverter::FacebookToIdentity.new.convert!(user)
      puts "Please send password reset to #{args.email}"
    end
  end

  namespace :images do
    desc 'Convert image kinds to new v1 schema'
    task original_to_v1: :environment do
      Image.where(kind: 'hero', imageable_type: "Course").update_all(kind: 'class_hero')
      Image.where(kind: 'headline', imageable_type: 'Course').update_all(kind: 'icon_tall')
      Image.where(kind: 'generic', imageable_type: 'Course').update_all(kind: 'class_review')
      Image.where(kind: 'icon', imageable_type: 'Course').update_all(kind: 'banner')
    end

    desc "Convert image kinds from v1 to original"
    task v1_to_original: :environment do
      Image.where(kind: 'class_hero', imageable_type: "Course").update_all(kind: 'hero')
      Image.where(kind: 'icon_tall ',imageable_type: 'Course').update_all(kind: 'headline')
      Image.where(kind: 'class_review', imageable_type: 'Course').update_all(kind: 'generic')
      Image.where(kind: 'banner', imageable_type: 'Course').update_all(kind: 'icon')
    end
  end

  namespace :course_comments do
    desc 'Create base comment for each chapter'
    task :create_base_comments, [:user_id] => [:environment] do |t, args|
      init_hash = {
        comment: 'Leave a thoughtful comment',
        visible: true
      }
      chapters = Chapter.all
      chapters.each do |chapter|
        if chapter.comments.empty?
          chapter.comments.create(init_hash.merge({ course: chapter.course, user_id: args[:user_id] }))
          chapter.save!
        end
      end
    end
  end
end
