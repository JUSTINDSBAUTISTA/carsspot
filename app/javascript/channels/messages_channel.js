// app/javascript/channels/messages_channel.js
import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const messagesContainer = document.getElementById("messages-container");

  if (messagesContainer) {
    const recipientId = messagesContainer.getAttribute("data-messages-recipient-id-value");

    consumer.subscriptions.create({ channel: "MessagesChannel", recipient_id: recipientId }, {
      connected() {
        console.log(`Connected to MessagesChannel with recipient_id: ${recipientId}`);
      },

      disconnected() {
        console.log("Disconnected from the MessagesChannel.");
      },

      received(data) {
        console.log("Message received:", data);
        const messages = document.getElementById('messages');
        if (messages) {
          messages.insertAdjacentHTML('beforeend', data.message);
        }
      }
    });
  }
});
