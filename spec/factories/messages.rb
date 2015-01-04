# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    subject 'Message Subject'
    body 'Message Body'
  end
end
