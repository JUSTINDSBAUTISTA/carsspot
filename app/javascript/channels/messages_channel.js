// app/javascript/channels/messages_channel.js
import consumer from "./consumer";

// Create a single subscription to MessagesChannel with the necessary parameters
consumer.subscriptions.create({channel: "MessagesChannel", recipient_id: "theRecipientId"}, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to the MessagesChannel with recipient_id: theRecipientId.");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("Disconnected from the MessagesChannel.");
  },

  received(data) {
    // Log the received data
    console.log("Received data:", data);

    // Assuming 'data' is the HTML string of the message as per your log
    // Select the chat box element
    const chatBox = document.getElementById('chatBox');

    // Append the received message HTML to the chat box
    if (chatBox) {
      chatBox.innerHTML += data; // Append the message
    } else {
      console.log("Chat box not found.");
    }
  }
});
