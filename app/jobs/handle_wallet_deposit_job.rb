class HandleWalletDepositJob < ApplicationJob
  def perform(data)
    Webhooks::HandleWalletDepositService.call(data)
  end
end
