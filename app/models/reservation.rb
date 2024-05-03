class Reservation < ApplicationRecord

  validates :guest, presence: true
  validates :total, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}
  validates :user, :checkin_date, presence: true
  validates :checkout_date, presence: true, comparison: { greater_than: :checkin_date }
  validate :existing_reservation

  # has_one :payment
  belongs_to :user

  private

  def existing_reservation
    if Reservation.exists?(checkin_date: self.checkin_date..self.checkout_date, checkout_date: ..self.checkout_date)
      self.errors.add(:checkin_date, "A reservation already exists for either of the checkin or checkout date")
    end
  end

end
