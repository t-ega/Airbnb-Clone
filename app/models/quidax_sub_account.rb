class QuidaxSubAccount < ApplicationRecord
  # The id represents the sub account id on quidax
  validates :id, presence: true
  validates :user_id, presence: true

  belongs_to :user
end
