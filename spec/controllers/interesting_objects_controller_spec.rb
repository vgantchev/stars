require 'rails_helper'
require 'rack/test'

RSpec.describe InterestingObjectsController, type: :controller do
  let(:user) { User.find(1) }
  let(:user2) { User.find(2) }

  let(:valid_hash) {
    {
      name: 'Namez123',
      description: 'descr',
      user: user,
      photo: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/img/bmw.jpg', 'image/jpeg')
    }
  }

  describe "POST create" do
    before(:each) do
      sign_in(user)
    end

    context "with valid attributes" do
      it "creates the interesting_object" do
        expect {
          post :create, { interesting_object: valid_hash }
        }.to change(InterestingObject, :count).by(1)
      end

      it "redirects to the interesting object" do
        post :create, { interesting_object: valid_hash }
        expect(response).to redirect_to(interesting_object_path(InterestingObject.find_by(name: "Namez123")))
      end
    end

    context "with invalid attributes" do
      it "does not create the interesting_object" do
        expect {
          post :create, { interesting_object: valid_hash.merge( { photo: nil } ) }
        }.to change(InterestingObject, :count).by(0)
      end

      it "re-renders new" do
        post :create, { interesting_object: valid_hash.merge( { photo: nil } ) }
        expect(response).to render_template(:new)  
      end
    end
  end

  describe "POST update" do
    let(:interesting_object) { InterestingObject.find(1) }
    context "with a user who is not the owner" do
      it "does not update the interesting_object" do
        sign_in(user2)
        post :update, { id: interesting_object.id, interesting_object: { name: "qwas" } }
        expect(interesting_object.name).to_not eq("qwas")
      end
    end

    context "with a user who is not the owner" do
      it "does update the interesting_object" do
        sign_in(user)
        post :update, { id: interesting_object.id, interesting_object: { name: "qwas" } }
        interesting_object.reload
        expect(interesting_object.name).to eq("qwas")
      end
    end
  end

  describe "POST rate" do
    before(:each) do
      sign_in(user2)
    end

    let(:interesting_object) { InterestingObject.find(1) }

    context "when valid" do
      it "saves the rating" do
        expect {
          post :rate, { id: interesting_object.id, score: 3 }
        }.to change(Rating, :count).by(1)
      end

      it "updates the average_rating" do
        post :rate, { id: interesting_object.id, score: 3 }
        interesting_object.reload
        expect(interesting_object.average_rating).to_not eq(nil)
      end
    end

    context "when invalid" do
      it "does not save the rating" do
        expect {
          post :rate, { id: interesting_object.id, score: 6 }
        }.to change(Rating, :count).by(0)
      end

      it "does not update the average_rating" do
        post :rate, { id: interesting_object.id, score: 6 }
        interesting_object.reload
        expect(interesting_object.average_rating).to eq(nil)
      end
    end
  end

  describe "POST estimate_value" do
    before(:each) do
      sign_in(user2)
    end

    let(:interesting_object) { InterestingObject.find(1) }

    context "when valid" do
      it "saves the value_estimate" do
        expect {
          post :estimate_value, { id: interesting_object.id, value: 15000 }
        }.to change(ValueEstimate, :count).by(1)
      end

      it "updates the average_value_estimate" do
        post :estimate_value, { id: interesting_object.id, value: 15000 }
        interesting_object.reload
        expect(interesting_object.average_value_estimate).to_not eq(nil)
      end
    end

    context "when invalid" do
      it "does not save the rating" do
        expect {
          post :estimate_value, { id: interesting_object.id, value: -6 }
        }.to change(ValueEstimate, :count).by(0)
      end

      it "does not update the average_value_estimate" do
        post :estimate_value, { id: interesting_object.id, value: -6 }
        interesting_object.reload
        expect(interesting_object.average_value_estimate).to eq(nil)
      end
    end
  end
end