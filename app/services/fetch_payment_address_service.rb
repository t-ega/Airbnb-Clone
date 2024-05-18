class FetchPaymentAddressService < ApplicationService
  include QuidaxInitializer

  def initialize(host_id)
    @quidax_wallet = QuidaxWallet.new(self.class.quidax_object)
    @host_id = host_id
  end

  def call
    sub_account = QuidaxSubAccount.find_by_user_id(@host_id)
    return if sub_account.nil?

    host_address =
      HostPaymentAddress.find_by(sub_account_id: sub_account.account_id)

    return if host_address.nil? # No payment address data to fetch from quidax

    network = "trx" # Hosts would be paid trx by default. It has cheap gas fees.

    begin
      res =
        @quidax_wallet.get_payment_address(
          user_id: sub_account.account_id,
          currency: network
        )

      res = res.with_indifferent_access
      data = res[:data]
      return data
    rescue QuidaxServerError => e
      Rails.logger.error(e.response.body)
      return
    end
  end
end
