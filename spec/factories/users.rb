FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    first_name 'Tom'
    last_name 'Middleton'
    permissions { { 'admin' => false, 'comments' => true } }
    profile

    factory :admin do
      permissions { { 'admin' => true, 'comments' => true } }
    end
  end
end
