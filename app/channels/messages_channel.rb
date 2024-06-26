# app/channels/messages_channel.rb
class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages_#{params[:recipient_id]}_channel"
  end

  def unsubscribed

  end
end
