class InterestingObject < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :ratings, dependent: :destroy
  has_many :value_estimates, dependent: :destroy

  # Validations
  validates :name, :description, :user, presence: true

  # Paperclip
  has_attached_file :photo, url: '/storage/:class/:id/:basename.:extension', styles: { medium: '250x250>' }
  validates_attachment :photo, presence: true, content_type: { content_type: ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png'] }

  # Scopes
  default_scope { order(created_at: :desc) }

  def calculate_average_rating
    ratings.sum(:score) / ratings.size.to_d
  end

  def update_average_rating
    update(average_rating: calculate_average_rating)
  end

  def calculate_average_value_estimate
    value_estimates.sum(:value) / value_estimates.size.to_d
  end

  def update_average_value_estimate
    update(average_value_estimate: calculate_average_value_estimate)
  end

end
