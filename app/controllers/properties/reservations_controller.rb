module Properties
  class ReservationsController < ApplicationController
    before_action :set_property_data, only: %i[new]
    before_action :reservation_params, only: %i[new]

    def new
      @formatted_checkin_date = Date.parse(reservation_params[:checkin_date]).strftime("%B %e, %Y")
      @formatted_checkout_date = Date.parse(reservation_params[:checkout_date]).strftime("%B %e, %Y")
      @property_name = @property.name
      @total = Reservation.calculate_total(@property.id, reservation_params[:checkin_date], reservation_params[:checkout_date])
      # reservation = Reservation.book_reservation(reservation_params)
      # if reservation.errors
      #   render :new
      # else
      #   flash[:success] = "Reservation successfully booked. Remember \"payment\" confirms reservation"
      #   redirect :propert_path
      # end
    end

    private
    def reservation_params
      params.permit(:guest_id, :property_id, :total, :checkin_date,:checkout_date)
    end

    def set_property_data
      @property = Property.find(params[:property_id])
    end

  end
end
