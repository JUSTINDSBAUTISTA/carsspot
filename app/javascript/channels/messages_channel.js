import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const recipientElement = document.getElementById('chat-recipient-id')
  const recipient_id = recipientElement.getAttribute('data-recipient-id')

  consumer.subscriptions.create({ channel: "MessagesChannel", recipient_id: recipient_id }, {
    connected() {
      console.log("Connected to the messages channel " + recipient_id)
    },

    disconnected() {
      console.log("Disconnected from the messages channel " + recipient_id)
    },

    received(data) {
      const chatContainer = document.getElementById('chat-container')
      chatContainer.innerHTML += `<div class="message">${data.message}</div>`
    },

    sendMessage: function(message) {
      return this.perform('receive', { message: message });
    }
  });

  const input = document.getElementById('chat-input')
  input.addEventListener('keypress', (event) => {
    if (event.keyCode === 13 && input.value !== '') {
      const message = input.value
      consumer.subscriptions.subscriptions[0].sendMessage(message)
      input.value = ''
      event.preventDefault()
    }
  })
});
