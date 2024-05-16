class WebhookController < ApplicationController
  before_action :protect_webhook

  def execute
    data = params[:body]
    return if data.nil?

    event = data[:event]
    body = data[:data]
    puts body

    case event
    when "wallet.address.generated"
      HandleWalletGeneratedJob.perform_later(body)
    when ""
    end
    return render json: { message: "Success" }
  end

  private

  def protect_webhook
    my_webhook_key = ENV["quidax-signature"]
    webhookKey = request.headers["quidax-signature"]

    if webhookKey != my_webhook_key
      return(
        render :json,
               { message: "You are not allowed to perform this action" },
               status: 403
      )
    end
  end
end
