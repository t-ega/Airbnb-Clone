class CreateReservationService < ApplicationService
    def initialize(property_id,  checkin_date, checkout_date, wallet_address)
        @property_id = property_id
        @checkin_date = checkin_date
        @checkout_date = checkout_date
        @wallet_address = wallet_address
    end

    def call
    # Ensure the wallet address belongs to a host
    address_valid = HostPaymentAddress.find_by_address(reservation_details[:wallet_address])
    return if address_valid.nil?
    
    total = Reservation.calculate_total(property_id, checkin_date, :checkout_date)
    Reservation.create({total:total, property_id:property_id, checkin_date: checkin_date, checkout_date: checkout_date, wallet_address: wallet_address })
    end
end