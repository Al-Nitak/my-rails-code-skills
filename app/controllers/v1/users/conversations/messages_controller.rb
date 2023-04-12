# frozen_string_literal: true

class V1::Users::Conversations::MessagesController < V1::Users::BaseController
  before_action :set_conversation, only: [:index, :create, :typing, :destroy]

  # GET /messages
  def index
    @messages = Message.by_conversation(@conversation.id)
    paginate(collection: @messages.order(created_at: :desc))
  end

  # POST /messages
  def create
    result = Conversation::Organizers::SendMessage.call(
      message_params: message_params,
      sender: current_user,
      conversation: @conversation,
      transmit_type: 'NEW_MESSAGE'
    )

    if result.success?
      head(:ok)
    else
      render(json: result.errors, status: :unprocessable_entity)
    end
  end

  # POST /messages/typing
  def typing
    message = { typing: { sender: current_user, status: params[:typing], sender_type: 'User' } }
    Conversation::TransmitMessage.call(conversation: @conversation, message: message)
    head(:ok)
  end

  def destroy
    message = Message.delete_user_message(@conversation.id, current_user.id, message_params[:message_id])

    if message.blank?
      head(:unprocessable_entity)

    else
      render(json: message)

    end
  end

  private

  def message_params
    params.require(:message).permit(:message_id, :body, :attachment)
  end

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
end
