class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = policy_scope(Message.where("sender_id = :current_user_id OR recipient_id = :current_user_id", current_user_id: current_user.id)
                             .select(Arel.sql("DISTINCT ON (GREATEST(sender_id, recipient_id), LEAST(sender_id, recipient_id)) *"))
                             .order(Arel.sql("GREATEST(sender_id, recipient_id), LEAST(sender_id, recipient_id), created_at DESC")))

    if params[:recipient_id].present?
      @recipient = User.find(params[:recipient_id])
      @messages = policy_scope(Message).where(
        "(sender_id = :current_user_id AND recipient_id = :recipient_id) OR (sender_id = :recipient_id AND recipient_id = :current_user_id)",
        current_user_id: current_user.id, recipient_id: @recipient.id
      ).order(:created_at)
    end

    @message = Message.new
    @unread_messages_count = current_user.received_messages.where(read: false).count
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    authorize @message

    if @message.save
      message_html = render_message(@message)
      Rails.logger.debug "Rendered message: #{message_html.inspect}"
      ActionCable.server.broadcast "messages_#{@message.recipient_id}_channel", message_html

      respond_to do |format|
        format.html { redirect_to messages_path(recipient_id: @message.recipient_id) }
        format.turbo_stream { render turbo_stream: turbo_stream.append('messages', partial: 'messages/message', locals: { message: @message }) }
      end
    else
      Rails.logger.debug "Message save failed: #{@message.errors.full_messages}"
      render :index
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :recipient_id)
  end

  def render_message(message)
    render_to_string(
      partial: 'messages/message',
      locals: { message: message, current_user: current_user }
    )
  end
end
