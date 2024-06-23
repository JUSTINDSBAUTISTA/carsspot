// app/javascript/channels/notification_channel.js
import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    console.log("Connected to the Notification Channel")
  },

  disconnected() {
    console.log("Disconnected from the Notification Channel")
  },

  received(data) {
    const controller = document.querySelector("[data-controller='notifications']")
    if (controller) {
      controller.dispatchEvent(new CustomEvent("notification-received", { detail: data }))
    }
  }
})
