class Reservation < ApplicationRecord
  SERVICE_FEE = 0.2.freeze # would be added to the total_price
  validates :guest_id, presence: true
  validates :property_id, presence: true
  validates :total, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}
  validate :checkin_date_cannot_be_in_the_past
  validates :checkin_date, presence: true
  validates :checkout_date, presence: true, comparison: { greater_than: :checkin_date }
  validate :overlapping_reservations

  belongs_to :guest, class_name: "User"
  belongs_to :property

  def self.calculate_total(property_id, checkin_date, checkout_date)
    days = (checkout_date - checkin_date).to_i
    property = Property.find(property_id)
    gross = (property.price * days)
     (gross + (Reservation::SERVICE_FEE * gross))
  end


  private

  def overlapping_reservations
    overlapping = Reservation.where(
      "property_id = ? AND (checkout_date <= ? OR checkin_date >= ?)",
      property_id,
      checkout_date,
      checkin_date
    ).exists?

    self.errors.add(:checkin_date, "A reservation already exists for either of the checkin or checkout date") if overlapping
    self.errors.add(:checkout_date, "A reservation already exists for either of the checkin or checkout date") if overlapping

  end

  def checkin_date_cannot_be_in_the_past
    if checkin_date.present? && checkin_date < Date.today
      errors.add(:checkin_date, "can't be in the past")
    end
  end


end
