class CreateReservationService < ApplicationService
  def initialize(
    property_id,
    checkin_date,
    checkout_date,
    wallet_address,
    estimated_crypto_amount,
    guest_id
  )
    @property_id = property_id
    @checkin_date = checkin_date
    @checkout_date = checkout_date
    @wallet_address = wallet_address
    @estimated_crypto_amount = estimated_crypto_amount
    @guest_id = guest_id
  end

  def call
    # Ensure the wallet address belongs to a host
    address_valid = HostPaymentAddress.find_by_address(@wallet_address)
    return if address_valid.nil?

    @total =
      Reservation.calculate_total(@property_id, @checkin_date, @checkout_date)
    Reservation.create(
      {
        total: @total,
        estimated_crypto_amount: @estimated_crypto_amount,
        property_id: @property_id,
        checkin_date: @checkin_date,
        guest_id: @guest_id,
        checkout_date: @checkout_date,
        wallet_address: @wallet_address
      }
    )
  end
end
