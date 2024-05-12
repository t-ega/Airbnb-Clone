class QuidaxSubAccount < ApplicationRecord
  validates :id, presence: true
  validates :email, presence: true
  validates :user_id, presence: true

  belongs_to :user
end
