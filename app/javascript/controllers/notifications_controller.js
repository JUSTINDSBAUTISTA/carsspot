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
    // Check if the notification already exists
    if (!this.listTarget.querySelector(`[data-notification-id="${data.notification.id}"]`)) {
      this.listTarget.insertAdjacentHTML('beforeend', data.notification)
    }
  }

  markAsRead(event) {
    const notificationId = event.currentTarget.dataset.notificationId;
    const notificationElement = this.listTarget.querySelector(`[data-notification-id="${notificationId}"]`);

    // Send a request to mark the notification as read
    fetch(`/notifications/${notificationId}/mark_as_read`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ id: notificationId })
    }).then(response => {
      if (response.ok) {
        notificationElement.classList.remove('unread');
      }
    });
  }
}
