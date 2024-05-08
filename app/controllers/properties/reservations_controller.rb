module Properties
  class ReservationsController < ApplicationController
    before_action :ensure_user_is_logged_in
    before_action :set_property_data, only: %i[new]
    before_action :format_date_params, only: %i[new]
    before_action :reservation_params, only: %i[new]

    def new
      @property_name = @property.name
      @total = Reservation.calculate_total(@property.id, @checkin_date, @checkout_date)

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
      params.permit(:property_id, :checkin_date,:checkout_date)
    end

    def format_date_params

      begin
        @checkin_date = Date.parse(reservation_params[:checkin_date])
        @checkout_date =  Date.parse(reservation_params[:checkout_date])
        @formatted_checkin_date = @checkin_date.strftime("%B %e, %Y")
        @formatted_checkout_date = @checkout_date.strftime("%B %e, %Y")
      rescue Date::Error
        flash[:alert] = "Invalid request"
        redirect_to home_index_path
      end

    end

    def set_property_data
      @property = Property.find(params[:property_id])
    end

  end
end
