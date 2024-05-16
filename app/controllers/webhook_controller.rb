class WebhookController < ApplicationController
  before_action :protect_webhook
  skip_before_action :verify_authenticity_token

  def execute
    event = params["event"]
    body = webhook_params

    case event
    when "wallet.address.generated"
      HandleWalletGeneratedJob.perform_later(body)
    when "deposit.transaction.confirmation"
      HandleWalletDepositConfirmationJob.perform_later(body)
    when "deposit.successful"
      HandleWalletDepositJob.perform_later(body)
    end
    return render json: { message: "Success" }
  end

  private

  def protect_webhook
    my_webhook_key = ENV["QUIDAX_SIGNATURE"]
    webhookKey = request.headers["quidax-signature"]

    if webhookKey != my_webhook_key
      render json: {
               message: "You are not allowed to perform this action"
             },
             status: 403
      return
    end
  end

  def webhook_params
    # If the quidax signature is right then we can allow all values
    params.require(:data).permit!
  end
end
