# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "username#{n}" }
  end

  factory :post do
    sequence(:title) {|n| "A dummy title #{n}" }
  end

end
