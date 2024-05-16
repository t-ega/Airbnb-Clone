class HandleWalletGeneratedService < ApplicationService
  def initialize(data)
    @data = data.with_indifferent_access
  end

  def call
    puts @data
    payment_address =
      HostPaymentAddress.find_by_id(@data[:id], network: @data[:currency])
    # If the payment address does not exit in the database it is probably because
    # the address generation was not initiated from the system.
    return if payment_address.nil?

    payment_address.update!(address: @data[:address])
  end
end
