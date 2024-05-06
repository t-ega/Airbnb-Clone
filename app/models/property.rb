class Property < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :headline, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :city, presence: true
  validates :address, presence: true
  # Some properties might be free
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :host, presence: true

  has_many :reviews, dependent: :destroy, as: :reviewable
  belongs_to :host, class_name: "User"
  has_many :reservations, dependent: :destroy

  def self.upload_image(image, property_id)
    uploader = ImageUploaderJob.new
    uploader.upload_image_and_update_attribute(image, Property, property_id, :image_url)
  end

end
