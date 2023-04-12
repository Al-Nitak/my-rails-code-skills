# frozen_string_literal: true

class ConversationChannel < ApplicationCable::Channel
  def subscribed
    key = generate_transmit_key
    stream_from(key)
  end

  def unsubscribed
    key = generate_transmit_key
    message = { typing: { sender: current_user, status: false, sender_type: current_user.class.name } }
    ActionCable.server.broadcast(key, message)
  end

  private

  def generate_transmit_key
    conversations = current_user.class.name == 'User' ? current_user.conversations : Conversation.all
    @conversation = conversations.find_by_id(params[:conversation])
    "conversation_#{@conversation.id}"
  end
end
