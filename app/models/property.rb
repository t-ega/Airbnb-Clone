class Property < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :headline, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :city, presence: true
  validates :address, presence: true
  # Some properties might be free
  validates :price,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }
  validates :host, presence: true

  has_many :reviews, dependent: :destroy, as: :reviewable
  belongs_to :host, class_name: "User"
  has_many :reservations, dependent: :destroy

  # Call a service to upload the property image.
  def self.upload_image(image, property_id)
    ImageUploaderService.upload_model_image(
      image: image,
      model_class: Property,
      model_id: property_id,
      attribute_name: :image_url
    )
  end

  # Using this method would always trigger an ActiveRecordNot found
  # exception it the specified property with that host does not exists
  def self.find_host_property(property_id, host)
    property = Property.find_by!(id: property_id, host: host)
    property
  end
end
