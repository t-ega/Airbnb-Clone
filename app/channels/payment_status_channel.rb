class PaymentStatusChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "payment_status_#{params[:wallet_address]}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
