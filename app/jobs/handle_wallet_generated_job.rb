class HandleWalletGeneratedJob < ApplicationJob
  def perform(data)
    HandleWalletGeneratedService.call(data)
  end
end
