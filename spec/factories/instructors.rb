# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :instructor do
    name "Alton Brown"
    short_bio "Television chef"
    long_bio "Many delicious ideas"
    email "alton@example.com"
  end
end
