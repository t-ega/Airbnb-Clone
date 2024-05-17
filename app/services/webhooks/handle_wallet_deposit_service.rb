module Webhooks
  class HandleWalletDepositService < ApplicationService
    include QuidaxInitializer

    def initialize(data)
      @data = data.with_indifferent_access
    end

    # After a webhook has been sent concerning deposit
    # we need to reconfirm the balance in the account before releasing
    # value to the user. Or in this case a reservation
    def call
      # reterive the payment address in order to get the host
      payment_address = @data.dig(:payment_address, :address)
      deposit_id = @data[:id]

      host = HostPaymentAddress.find_by_address(payment_address)
      return if host.nil?

      reservation =
        Reservation.where(
          "wallet_address= ? AND ? >= estimated_crypto_amount",
          payment_address,
          @data[:amount]
        ).last # The most recent reservation
      return if reservation.nil?

      begin
        res =
          QuidaxDeposits.get_a_deposit(
            q_object: self.class.quidax_object,
            user_id: host.sub_account_id,
            deposit_id: deposit_id
          )
      rescue QuidaxServerError => e
        Rails.logger.error(e.response.body)
        reservation.update!(payment_status: PaymentStatus::FAILED)
        ActionCable.server.broadcast "payment_status_#{payment_address}_channel",
                                     { status: "Failed" }
        return
      end

      result = res.with_indifferent_access
      confrimation_status = result.dig(:payment_transaction, :status)
      return if confrimation_status != "confirmed"

      # TODO: Send email to host about payment
      reservation.update!(payment_status: PaymentStatus::Confirmed)
      ActionCable.server.broadcast "payment_status_#{payment_address}_channel",
                                   { status: "Confirmed" }
    end
  end
end
