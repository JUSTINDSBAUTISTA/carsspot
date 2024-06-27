import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { recipientId: Number }
  static targets = ["messages", "form"]

  connect() {
    this.subscription = createConsumer().subscriptions.create(
      { channel: "MessagesChannel", recipient_id: this.recipientIdValue },
      {
        received: data => this.#insertMessageAndScrollDown(data)
      }
    )
    console.log(`Subscribed to the chatroom with the recipient id ${this.recipientIdValue}.`)
  }

  disconnect() {
    console.log("Unsubscribed from the chatroom")
    this.subscription.unsubscribe()
  }

  #insertMessageAndScrollDown(data) {
    console.log("Message received:", data);
    this.messagesTarget.insertAdjacentHTML("beforeend", data.message)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
  }

  resetForm(event) {
    event.preventDefault()
    this.formTarget.reset()
  }
}
