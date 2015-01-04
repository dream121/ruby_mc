# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :image do
    imageable_id 1
    imageable_type "Course"
    kind "hero"
    # image File.new(Rails.root + 'spec/factories/images/rails.png')
  end
end
