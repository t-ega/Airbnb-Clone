class PaymentStatusChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "payment_status_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def test_f
    ActionCable.server.broadcast "payment_status_channel", {data: "Heyyy"}
  end
end
