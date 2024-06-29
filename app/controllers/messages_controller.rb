class MessagesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @messages = policy_scope(Message) # Ensure policy_scope is called before accessing @messages

    if params[:recipient_id].present?
      @recipient = User.find(params[:recipient_id])
      if !conversation_allowed?(current_user, @recipient)
        redirect_to root_path, alert: "You are not allowed to start a conversation with this user."
        return
      end

      authorize @recipient, :message?
      @messages = @messages.where(sender: current_user, recipient: @recipient)
                           .or(@messages.where(sender: @recipient, recipient: current_user))
                           .order(created_at: :asc)
    else
      @recipient = nil
      @messages = @messages.where(sender: current_user)
                           .or(@messages.where(recipient: current_user))
                           .order(created_at: :asc)
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
      respond_to do |format|
        format.html { redirect_to messages_path(recipient_id: @message.recipient_id) }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to messages_path, alert: "Message could not be sent." }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("form-container", partial: "messages/form", locals: { message: @message }) }
      end
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

  def conversation_allowed?(user, recipient)
    CarView.exists?(user: user, car: recipient.cars) ||
    CarView.exists?(user: recipient, car: user.cars) ||
    Message.exists?(sender: user, recipient: recipient) ||
    Message.exists?(sender: recipient, recipient: user)
  end
end
