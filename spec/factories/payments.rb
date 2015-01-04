# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    order
    transaction_id "MyString"
    response {{ 'foo' => 'bar' }}
    amount 9999
    paid false
    refunded false
    amount_refunded 0
  end
end
