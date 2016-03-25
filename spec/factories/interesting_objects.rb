FactoryGirl.define do
  factory :interesting_object do
    name "Name"
    description 'descr'
    user User.find(1)
    photo { File.new(Rails.root + 'spec/fixtures/img/bmw.jpg') }
  end
end
