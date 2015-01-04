# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chapter do
    number 1
    duration "4:00"
    title "Chapter One"
    brightcove_id "123"
    slug 'chapter-one'
  end
end
