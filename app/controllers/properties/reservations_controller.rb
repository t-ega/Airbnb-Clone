module Properties
  class ReservationsController < ApplicationController
    before_action :reservation_params, only: %i[create]
    def new
      reservation = Reservation.book_reservation(reservation_params)
      if reservation.errors
        puts reservation.errors
      end
    end

    private
    def reservation_params
      params.permit(:guest_id, :property_id, :total, :checkin_date,:checkout_date)
    end

  end
end
