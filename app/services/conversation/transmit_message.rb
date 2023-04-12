# frozen_string_literal: true

class Conversation::TransmitMessage
  include Interactor
  delegate :message, :conversation, :transmit_type, :fail!, to: :context

  def call
    ActionCable.server.broadcast(conversation_transmit_key, message)

    if transmit_type.present?
      conversation.conversation_participants.each do |conversation_participant|
        participant = conversation_participant.participant
        ActionCable.server.broadcast("general_#{participant.class.name}_#{participant.id}",
          type: transmit_type, conversation: conversation.id)
      end

      Admin.all.each do |admin|
        ActionCable.server.broadcast("general_Admin_#{admin.id}",
          type: transmit_type, conversation: conversation.id)
      end
    end
  end

  def conversation_transmit_key
    "conversation_#{conversation.id}"
  end
end
