# frozen_string_literal: true

class Conversation::JoinConversation
  include Interactor
  delegate :conversation, :participants, :fail!, to: :context

  def call
    return unless participants.present?
    conversation.update(conversation_participants_attributes: participants)
  end
end
