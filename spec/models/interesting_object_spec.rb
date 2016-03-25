require 'rails_helper'

RSpec.describe InterestingObject, type: :model do
  let(:user) { User.first }

  let(:valid_hash) {
    {
      name: 'Name',
      description: 'descr',
      user: user,
      photo: File.new(Rails.root + 'spec/fixtures/img/bmw.jpg')
    }
  }

  context "when creating a new interesting object" do
    it "is valid with all mandatory attributes" do
      interesting_object = InterestingObject.create(valid_hash)
      expect(interesting_object).to be_valid
    end

    it "is not valid without a name" do
      interesting_object = InterestingObject.create(valid_hash.merge( { name: nil } ))
      expect(interesting_object).to_not be_valid
    end

    it "is not valid without a user" do
      interesting_object = InterestingObject.create(valid_hash.merge( { user: nil } ))
      expect(interesting_object).to_not be_valid
    end

    it "is not valid without a description" do
      interesting_object = InterestingObject.create(valid_hash.merge( { description: nil } ))
      expect(interesting_object).to_not be_valid
    end

    it "is not valid without a photo" do
      interesting_object = InterestingObject.create(valid_hash.merge( { photo: nil } ))
      expect(interesting_object).to_not be_valid
    end
  end

  context "when calculating and updating the rating averages" do
    let(:interesting_object) { InterestingObject.find(1) }
    before(:each) do
      FactoryGirl.create(:rating)
      FactoryGirl.create(:rating2)
      FactoryGirl.create(:rating3)
    end

    describe "calculate average_rating" do
      it "calculates correctly" do
        expected_average_rating = interesting_object.ratings.sum(:score) / 3.to_d
        calculated_average_rating = interesting_object.calculate_average_rating
        expect(calculated_average_rating).to eq(expected_average_rating)
      end
    end

    describe "update average_rating" do
      it "updates correctly" do
        # Nilify to test update of calculated value
        interesting_object.update(average_rating: nil)
        expected_average_rating = interesting_object.ratings.sum(:score) / 3.to_d
        interesting_object.update_average_rating
        expect(interesting_object.average_rating).to eq(expected_average_rating)
      end
    end
  end

  context "when calculating and updating the value average" do
    let(:interesting_object) { InterestingObject.find(1) }
    before(:each) do
      FactoryGirl.create(:value_estimate)
      FactoryGirl.create(:value_estimate2)
      FactoryGirl.create(:value_estimate3)
    end

    describe "calculate_average_value_estimate" do
      it "calculates correctly" do
        expected_average_value_estimate = interesting_object.value_estimates.sum(:value) / 3
        calculated_average_value_estimate = interesting_object.calculate_average_value_estimate
        expect(calculated_average_value_estimate).to eq(expected_average_value_estimate)
      end
    end

    describe "update_average_value_estimate" do
      it "updates correctly" do
        # Nilify to test update of calculated value
        interesting_object.update(average_value_estimate: nil)
        expected_average_value_estimate = interesting_object.value_estimates.sum(:value) / 3
        interesting_object.update_average_value_estimate
        expect(interesting_object.average_value_estimate).to eq(expected_average_value_estimate)
      end
    end
  end
end
