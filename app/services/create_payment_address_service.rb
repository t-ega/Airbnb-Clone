class CreatePaymentAddressService < ApplicationService
  include QuidaxInitializer

  def initialize(host_id)
    @host_id = host_id
  end

  def call
    payment_currency = "trx"
    payment_network = "trc20"

    payment_address =
      HostPaymentAddress.find_by_host_and_currency(@host_id, payment_currency)
    return if payment_address.address.nil?

    sub_account = QuidaxSubAccount.find_by_user_id(@host_id)
    if sub_account.nil?
      Rails.logger.warn(
        "Sub account not found for user with id: #{@host_id}. Payment address can't be created"
      )
      return # A subaccount must exist before the user can create an payment adress
    end

    begin
      payment_address =
        QuidaxWallet.create_crypto_payment_address(
          q_object: self.class.quidax_object,
          user_id: sub_account.id,
          currency: payment_currency
        )
    rescue QuidaxServerError => e
      Rails.logger.error(e.response.body)
      return
    end

    host = User.find(@host_id)
    return if host.nil?

    result = payment_address.with_indifferent_access
    data = result[:data]

    HostPaymentAddress.create(
      address: data[:address] || "",
      address_id: data[:id],
      host: @host_id,
      network: payment_network,
      sub_account_id: "blank",
      currency: data[:currency],
      email: host.email
    )
  end
end