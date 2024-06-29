import { Controller } from "@hotwired/stimulus";
import { createConsumer } from "@rails/actioncable";

export default class extends Controller {
  static values = { recipientId: Number };
  static targets = ["messages", "form"];

  connect() {
    if (this.subscription) {
      this.subscription.unsubscribe();
    }

    this.subscription = createConsumer().subscriptions.create(
      { channel: "MessagesChannel", recipient_id: this.recipientIdValue },
      {
        received: data => this.insertMessageAndScrollDown(data.message),
        connected: () => console.log(`Subscribed to the chatroom with the recipient id ${this.recipientIdValue}.`),
        disconnected: () => console.log("Unsubscribed from the chatroom")
      }
    );
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe();
    }
  }

  insertMessageAndScrollDown(messageHTML) {
    console.log("Message received:", messageHTML);

    const messagesContainer = this.messagesTarget;

    // Insert the new message at the end of the container
    messagesContainer.insertAdjacentHTML("beforeend", messageHTML);

    // Always scroll to the bottom when a new message is received
    this.scrollToBottom();
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }

  resetForm(event) {
    event.preventDefault();
    this.formTarget.reset();
    // Scroll to the bottom when a new message is sent
    this.scrollToBottom();
  }
}
