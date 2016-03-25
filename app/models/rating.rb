class Rating < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :interesting_object

  # Validations
  validates :user, :interesting_object, :score, presence: true
  validates :score, inclusion: { in: 1..5 }
  validate :one_per_user, on: :create
  validate :owner_cannot_rate

  # Callbacks
  after_save :update_average_rating

  private

  def update_average_rating
    interesting_object.update_average_rating
  end

  def one_per_user
    existing_rating = interesting_object.ratings.find_by(user: user)
    errors.add(:base, "You have already voted") if existing_rating
  end

  def owner_cannot_rate
    errors.add(:base, "You cannot rate your own special object.") if user == interesting_object.user
  end
end
