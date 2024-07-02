import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["list"]

  connect() {
    this.subscription = createConsumer().subscriptions.create("NotificationChannel", {
      received: this.handleReceived.bind(this)
    })
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
  }

  handleReceived(data) {
    this.listTarget.insertAdjacentHTML('beforeend', data.notification)
  }
}
