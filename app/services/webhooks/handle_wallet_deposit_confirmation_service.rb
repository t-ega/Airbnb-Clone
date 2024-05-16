module Webhooks
  class HandleWalletDepositConfirmationService < ApplicationService
    def initialize(data)
      @data = data.with_indifferent_access
    end

    def call
      reservation =
        Reservation.find_by_wallet_address(@data[:payment_address][:address])
      return if reservation.nil?

      reservation.update!(status: PaymentStatus::PROCESSING)

      ActionCable.server.broadcast "payment_status_#{reservation.wallet_address}_channel",
                                   { status: "Processing" }
    end
  end
end
