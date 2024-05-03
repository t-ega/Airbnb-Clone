class Property < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :headline, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :city, presence: true
  validates :address, presence: true
  validates :host, presence: true

  has_many_attached :images, dependent: :destroy
  has_many :reviews, dependent: :destroy, as: :reviewable
  belongs_to :host, class_name: "User"
  has_many :reservations, dependent: :destroy

end
