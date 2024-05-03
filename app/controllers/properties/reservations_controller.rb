module Properties
  class ReservationsController < ApplicationController
    before_action :reservation_params, only: %i[create]
    def new

      begin
        @property = Property.find(reservation_params[:property_id])
      rescue NotFoundError
        return render ""
      end

      @reservation = Reservation.new(reservation_params)
      if @reservation.save
        render "properties"
      else
        render @reservation.errors
      end
    end

    private
    def reservation_params
      params.permit(:guest_id, :property_id, :total, :checkin_date,:checkout_date)
    end

  end
end
