# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    ignore do
      chapter_count 0
    end

    available_now true
    sequence(:title) { |n| "Baking Bread Level #{n}" }
    sequence(:slug) { |n| "baking-bread-level-#{n}" }
    price 10000
    start_date Time.parse("2013-10-01")

    after(:create) do |course, evaluator|
      create :course_detail, course: course
      create :course_product, course: course

      (0...evaluator.chapter_count).each do |n|
        create :chapter, course: course, number: n+1
      end

      course.reload
    end
  end

  trait :upcoming do
    available_now false
  end

  trait :recommended do
    available_now true
  end
end
