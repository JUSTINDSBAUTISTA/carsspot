class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @received_messages = policy_scope(current_user.received_messages)
    @sent_messages = policy_scope(current_user.sent_messages)
    authorize Message
  end

  def new
    @message = Message.new(recipient_id: params[:recipient_id])
    authorize @message
  end

  def create
    @message = current_user.sent_messages.new(message_params)
    authorize @message
    if @message.save
      redirect_to messages_path, notice: 'Message was successfully sent.'
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:recipient_id, :body)
  end
end
