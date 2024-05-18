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

  def wallet_address
    host_payment_address = HostPaymentAddress.find_by(host: host)

    if host_payment_address.nil? || host_payment_address.address.blank?
      CreatePaymentAddressJob.perform_later(host.id)
      return
    end

    [host_payment_address[:address], host_payment_address[:currency]]
  end

  private

  def fetch_wallet_address
  end
end
