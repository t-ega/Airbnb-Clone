class FetchPaymentsAddress < ApplicationService
  def initialize(host_id)
    secret_key = ENV["QUIDAX_SECRET_KEY"]
    @quidax_object = Quidax.new(secret_key)
    @quidax_user = QuidaxUser.new(@quidax_object)
    @host_id = host_id
  end

  def call
    sub_account = QuidaxSubAccount.find_by_user_id(@host_id)
    return sub_account if sub_account.nil?

    address = HostPaymentAddress.find_by(sub_account_id: sub_account.id)
    return address if address.present?

    network = "trx"

    begin
      res = @quidax_user.get_payment_address("me", network)
    rescue QuidaxServerError => e
      puts e.response.body
      Rails.logger.info(e.response.body)
    end

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
