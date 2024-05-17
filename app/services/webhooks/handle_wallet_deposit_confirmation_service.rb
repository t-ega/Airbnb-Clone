module Webhooks
  class HandleWalletDepositConfirmationService < ApplicationService
    def initialize(data)
      @data = data.with_indifferent_access
    end

    def call
      reservation =
        Reservation.where(
          "wallet_address= ? AND ? >= estimated_crypto_amount",
          @data[:payment_address][:address],
          @data[:amount]
        ).take
      return if reservation.nil?

      reservation.update!(payment_status: PaymentStatus::PROCESSING)

      ActionCable.server.broadcast "payment_status_#{reservation.wallet_address}_channel",
                                   { status: "Processing" }
    end
  end
end
