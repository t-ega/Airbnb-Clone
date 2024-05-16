class HandleWalletGeneratedJob < ApplicationJob
  def perform(data)
    Webhooks::HandleWalletGeneratedService.call(data)
  end
end
