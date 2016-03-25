FactoryGirl.define do
  factory :rating do
    user { User.find_by(name: 'user2') }
    interesting_object  { InterestingObject.first }
    score { rand(1..5) }
  end

  factory :rating2, class: Rating do
    user { User.find_by(name: 'user3') }
    interesting_object  { InterestingObject.first }
    score { rand(1..5) }
  end

  factory :rating3, class: Rating do
    user { User.find_by(name: 'user4') }
    interesting_object  { InterestingObject.first }
    score { rand(1..5) }
  end
end
