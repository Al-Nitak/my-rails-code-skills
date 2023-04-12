# frozen_string_literal: true

class V1::Admin::Conversations::MessagesController < V1::Admin::BaseController
  before_action :set_conversation, only: [:index]

  # GET /messages
  def index
    @messages = Message.by_conversation(@conversation.id)
    paginate(collection: @messages.order(created_at: :desc))
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
end
