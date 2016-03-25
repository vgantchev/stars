FactoryGirl.define do
  factory :user do
    name "Test User"
    email "test@example.com"
    password "please123"
  end

  factory :user2, class: User do
    name "user2"
    email "test2@example.com"
    password "please123"
  end

  factory :user3, class: User do
    name "user3"
    email "test3@example.com"
    password "please123"
  end

  factory :user4, class: User do
    name "user4"
    email "test4@example.com"
    password "please123"
  end
end
