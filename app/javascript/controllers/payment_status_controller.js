import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Connects to data-controller="payment-status"
export default class extends Controller {
  static targets = ["currentStatus", "walletAddress"]

  connect() {
    this.status_tag = this.currentStatusTarget;
    this.wallet_address = this.walletAddressTarget.value
    this.sub = this.createActionCableChannel()
  }

  createActionCableChannel() {
    return consumer.subscriptions.create({ channel: "PaymentStatusChannel", wallet_address: this.wallet_address }, {
      connected: () => {
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received: (data) => {
        // Called when there's incoming data on the websocket for this channel
        console.log(`Just received data: ${data}`)
        console.log(data)
        this.status_tag.textContent = data.status
      }
    });

  }
}
