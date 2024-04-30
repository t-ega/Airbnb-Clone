class Review < ApplicationRecord
  after_commit :update_property_average_review, only: %i[create update]
  validates :content, presence: true
  validates :title, presence: true
  validates :rating, presence: true, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 5, only_integer: true }
  validates :content, presence: true
  validates :reviewer, presence: true

  belongs_to :reviewable, polymorphic: true
  belongs_to :reviewer, class_name: "User"

  def update_property_average_review
    # We need to ensure that the reviewable table has an average_rating column
    reviewable.update!(average_rating: reviewable.reviews.average(:rating))
  end
end
