FactoryGirl.define do
  factory :value_estimate do
    user { User.find_by(name: 'user2') }
    interesting_object  { InterestingObject.first }
    value { rand(10..10000) }
  end

  factory :value_estimate2, class: ValueEstimate do
    user { User.find_by(name: 'user3') }
    interesting_object  { InterestingObject.first }
    value { rand(10..10000) }
  end

  factory :value_estimate3, class: ValueEstimate do
    user { User.find_by(name: 'user4') }
    interesting_object  { InterestingObject.first }
    value { rand(10..10000) }
  end
end
