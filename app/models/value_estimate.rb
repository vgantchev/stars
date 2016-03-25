class ValueEstimate < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :interesting_object

  # Validations
  validates :user, :interesting_object, :value, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 1000000 }
  validate :one_per_user, on: :create
  validate :owner_cannot_estimate

  # Callbacks
  after_save :update_average_value_estimate

  private

  def update_average_value_estimate
    interesting_object.update_average_value_estimate
  end

  def one_per_user
    existing_estimate = interesting_object.value_estimates.find_by(user: user)
    errors.add(:user, 'has already voted') if existing_estimate
  end

  def owner_cannot_estimate
    errors.add(:base, 'You cannot estimate the value your own special object.') if user == interesting_object.user
  end
end
