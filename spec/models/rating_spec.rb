require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:user) { User.find(2) }
  let(:interesting_object) { InterestingObject.find(1) }

  let(:valid_hash) {
    {
      user: user,
      interesting_object: interesting_object,
      score: 4
    }
  }

  context "when creating a new rating" do
    it "is valid with all mandatory attributes" do
      rating = Rating.create(valid_hash)
      expect(rating).to be_valid
    end

    it "is not valid when the rating is from the owner" do
      rating = Rating.create(valid_hash.merge( { user: User.find(1) } ))
      expect(rating).to_not be_valid
    end

    it "is not valid when the user has already rated" do
      Rating.create(valid_hash)
      rating = Rating.create(valid_hash)
      expect(rating).to_not be_valid
    end

    it "is not valid when score is above 5" do
      rating = Rating.create(valid_hash.merge( { score: 6 } ))
      expect(rating).to_not be_valid
    end

    it "is not valid when score is under 1" do
      rating = Rating.create(valid_hash.merge( { score: 0 } ))
      expect(rating).to_not be_valid
    end

    it "is not valid without a user" do
      rating = Rating.create(valid_hash.merge( { user: nil } ))
      expect(rating).to_not be_valid
    end

    it "is not valid without a score" do
      rating = Rating.create(valid_hash.merge( { user: nil } ))
      expect(rating).to_not be_valid
    end
  end

  describe "after_save update_average_rating" do
    before(:each) do
      FactoryGirl.create(:rating2)
      FactoryGirl.create(:rating3)
    end

    it "updates the average correctly" do
      new_score = rand(1..5)
      expected_average = (interesting_object.ratings.sum(:score) + new_score) / 3.to_d
      interesting_object.ratings.create(valid_hash.merge( { score: new_score } ))
      expect(interesting_object.average_rating).to eq(expected_average)
    end
  end
end
