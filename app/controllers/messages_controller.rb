class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = policy_scope(Message)
    @message = Message.new
  end

  def new
    @message = Message.new
    authorize @message
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    authorize @message
    if @message.save
      redirect_to messages_path
    else
      render :new
    end
  end

  def show
    @message = Message.find(params[:id])
    authorize @message
  end

  private

  def message_params
    params.require(:message).permit(:body, :recipient_id)
  end
end
