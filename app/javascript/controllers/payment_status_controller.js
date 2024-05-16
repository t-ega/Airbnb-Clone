import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Connects to data-controller="payment-status"
export default class extends Controller {
  connect() {
    console.log("Heyy")
    // this.sub = this.createActionCableChannel()
    // console.log(this.sub)
  }

  createActionCableChannel() {
    return consumer.subscription.create("payment_status_channel", {
      connected() {
        console.log("Yayy");
      },

      received(data) {
        console.log(data)
      }
    })

  }
}
