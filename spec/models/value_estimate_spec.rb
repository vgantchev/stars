require 'rails_helper'

RSpec.describe ValueEstimate, type: :model do
  let(:user) { User.find(2) }
  let(:interesting_object) { InterestingObject.find(1) }

  let(:valid_hash) {
    {
      user: user,
      interesting_object: interesting_object,
      value: 1200
    }
  }

  context "when creating a new value_estimate" do
    it "is valid with all mandatory attributes" do
      value_estimate = ValueEstimate.create(valid_hash)
      expect(value_estimate).to be_valid
    end

    it "is not valid when the value_estimate is from the owner" do
      value_estimate = ValueEstimate.create(valid_hash.merge( { user: User.find(1) } ))
      expect(value_estimate).to_not be_valid
    end

    it "is not valid when the user has already estimated" do
      ValueEstimate.create(valid_hash)
      value_estimate = ValueEstimate.create(valid_hash)
      expect(value_estimate).to_not be_valid
    end

    it "is not valid when value is above 1000000" do
      value_estimate = ValueEstimate.create(valid_hash.merge( { value: 1000001 } ))
      expect(value_estimate).to_not be_valid
    end

    it "is not valid when value is under 1" do
      value_estimate = ValueEstimate.create(valid_hash.merge( { value: 0 } ))
      expect(value_estimate).to_not be_valid
    end

    it "is not valid without a user" do
      value_estimate = ValueEstimate.create(valid_hash.merge( { user: nil } ))
      expect(value_estimate).to_not be_valid
    end

    it "is not valid without a value" do
      value_estimate = ValueEstimate.create(valid_hash.merge( { value: nil } ))
      expect(value_estimate).to_not be_valid
    end
  end

  describe "after_save update_average_value_estimate" do
    before(:each) do
      FactoryGirl.create(:value_estimate2)
      FactoryGirl.create(:value_estimate3)
    end

    it "updates the average correctly" do
      new_value = rand(1000..10000)
      expected_average = (interesting_object.value_estimates.sum(:value) + new_value) / 3.to_d
      interesting_object.value_estimates.create(valid_hash.merge( { value: new_value } ))
      expect(interesting_object.average_value_estimate).to eq(expected_average)
    end
  end
end
