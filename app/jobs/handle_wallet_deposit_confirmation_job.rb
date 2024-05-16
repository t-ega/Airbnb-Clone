class HandleWalletDepositConfirmationJob < ApplicationJob
    def perform(data)
        Webhooks::HandleWalletDepositConfirmationService.call(data)
    end
end