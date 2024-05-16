class CreatePaymentAddressJob < ApplicationJob
  def perform(data)
    CreatePaymentAddressService.call(data)
  end
end
