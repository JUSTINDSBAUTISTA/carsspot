class MessagesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    if params[:recipient_id].present?
      @recipient = User.find(params[:recipient_id])
      @messages = policy_scope(Message)
                    .where(sender: current_user, recipient: @recipient)
                    .or(policy_scope(Message).where(sender: @recipient, recipient: current_user))
                    .order(created_at: :asc)
    else
      @recipient = nil
      @messages = policy_scope(Message).where(sender: current_user).or(policy_scope(Message).where(recipient: current_user)).order(created_at: :asc)
    end

    sent_partners = current_user.sent_messages.includes(:recipient).map(&:recipient).compact.uniq
    received_partners = current_user.received_messages.includes(:sender).map(&:sender).compact.uniq
    @chat_partners = (sent_partners + received_partners).compact.uniq

    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.sender = current_user
    authorize @message

    if @message.save
      broadcast_message(@message)
      head :ok
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :recipient_id)
  end

  def broadcast_message(message)
    ActionCable.server.broadcast "messages_#{message.recipient_id}_channel", {
      message: render_message(message)
    }
  end

  def render_message(message)
    render_to_string partial: 'messages/message', locals: { message: message }
  end
end
