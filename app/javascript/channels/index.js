// app/javascript/channels/index.js
import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

// Import all your channels here
import "./messages_channel"
import "./notification_channel"
