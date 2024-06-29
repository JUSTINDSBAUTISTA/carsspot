import { Controller } from "@hotwired/stimulus";
import { createConsumer } from "@rails/actioncable";

export default class extends Controller {
  static values = { recipientId: Number, currentUserId: Number };
  static targets = ["messages", "form"];

  connect() {
    if (this.subscription) {
      this.subscription.unsubscribe();
    }

    this.subscription = createConsumer().subscriptions.create(
      { channel: "MessagesChannel", recipient_id: this.recipientIdValue, sender_id: this.currentUserIdValue },
      {
        received: data => this.insertMessageAndScrollDown(data.message),
        connected: () => console.log(`Subscribed to the chatroom with recipient id ${this.recipientIdValue} and sender id ${this.currentUserIdValue}.`),
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
    const messagesContainer = this.messagesTarget;
    messagesContainer.insertAdjacentHTML("beforeend", messageHTML);
    this.scrollToBottom();
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }

  sendMessage(event) {
    event.preventDefault();
    const messageInput = this.formTarget.querySelector('textarea');
    const message = messageInput.value.trim();

    if (message === '') {
      return;
    }

    this.subscription.perform('receive', { message: message });
    messageInput.value = ''; // Clear the input field after sending the message
    this.scrollToBottom();
  }
}
