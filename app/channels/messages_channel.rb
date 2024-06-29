class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages_#{params[:recipient_id]}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    message = Message.create!(
      body: data['message'],
      sender: current_user,
      recipient_id: params[:recipient_id]
    )
    ActionCable.server.broadcast("messages_#{params[:recipient_id]}_channel", message: render_message(message))
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
