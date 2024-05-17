module Properties
  class ReservationsController < ApplicationController
    before_action :ensure_user_is_logged_in
    before_action :set_property_data, only: %i[new create]
    before_action :set_reservation_data, only: %i[show]
    before_action :format_date_params, only: %i[new create]

    def new
      reservation = validate_reservation

      if reservation.valid?
        # current_price = FetchCryptoPrice.call(@currency)
        @estimated_price = @total / 0.10541
        return render :new
      end

      flash[:alert] = reservation.errors
      redirect_to property_path(@property)
    end

    def create
      # We could also lock the reservation while the guest pays
      # but that is out of the scope
      reservation = validate_reservation

      if reservation.save
        flash[
          :success
        ] = "Reservation successfully booked. Remember \"payment\" confirms reservation"
        return redirect_to property_reservation_path(@property, reservation)
      end

      flash[:alert] = reservation.errors
      redirect_to property_path(@property)
    end

    def show
      @estimated_price = @reservation.estimated_crypto_amount
      @total = @reservation.total
      @wallet_address, @currency = @reservation.property.wallet_address
      # current_price = FetchCryptoPrice.call(@currency)
      @estimated_price = @reservation.estimated_crypto_amount
    end

    private

    def reservation_params
      params.permit(
        :property_id,
        :checkin_date,
        :checkout_date,
        :wallet_address,
        :estimated_crypto_amount,
        :authenticity_token
      )
    end

    def format_date_params
      begin
        @checkin_date = Date.parse(reservation_params[:checkin_date])
        @checkout_date = Date.parse(reservation_params[:checkout_date])
      rescue Date::Error
        flash[:alert] = "Invalid request"
        redirect_to home_index_path
      end
    end

    def set_property_data
      @property = Property.find(params[:property_id])
      @property_name = @property.name
      @wallet_address, @currency = @property.wallet_address
    end

    def set_reservation_data
      @reservation = Reservation.includes(:property).find(params[:id])
      puts @reservation.payment_status.inspect
      if (
           @reservation.guest_id != current_user.id &&
             @reservation.property.host.id != current_user.id
         )
        raise ActiveRecord::RecordNotFound
      end
    end

    def validate_reservation
      @total =
        Reservation.calculate_total(@property.id, @checkin_date, @checkout_date)
      Reservation.new(
        property_id: reservation_params[:property_id],
        checkin_date: @checkin_date,
        checkout_date: @checkout_date,
        total: @total,
        payment_status: PaymentStatus::INITIATED, # TODO: Give a default payment status
        wallet_address: reservation_params[:wallet_address],
        estimated_crypto_amount: reservation_params[:estimated_crypto_amount],
        guest_id: current_user.id
      )
    end
  end
end
