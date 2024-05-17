class QuidaxSubAccount < ApplicationRecord
  self.primary_key = :user_id
  # The id represents the sub account id on quidax
  validates :id, presence: true
  validates :user_id, presence: true

  belongs_to :user, dependent: :destroy
end
