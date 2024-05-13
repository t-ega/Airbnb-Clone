class FetchPaymentAddressService < ApplicationService
  include QuidaxInitializer

  def initialize(host_id)
    @quidax_wallet = QuidaxWallet.new(self.class.quidax_object)
    @host_id = host_id
  end

  def call
    sub_account = QuidaxSubAccount.find_by_user_id(@host_id)
    return if sub_account.nil?

    address = HostPaymentAddress.find_by(sub_account_id: sub_account.id)
    return address if address.present?

    network = "trx" # Hosts would be paid trx by default. It has cheap gas fees.

    begin
      res =
        @quidax_wallet.get_payment_address(
          user_id: sub_account.id,
          currency: network
        )
    rescue QuidaxServerError => e
      puts e.response.body
      Rails.logger.error(e.response.body)
      return
    end

    res = res.with_indifferent_access
    data = res[:data]
    address =
      HostPaymentAddress.create(
        address: data[:address],
        address_id: data[:id],
        host: @host_id,
        network: network,
        sub_account_id: sub_account.id,
        currency: data[:currency],
        email: sub_account.email
      )
    return address if address.valid?
  end
end
