# frozen_string_literal: true

class Conversation::NewConversationBroadcast
  include Interactor
  delegate :conversation, :participants, :fail!, to: :context

  def call
    return unless participants.present?
    participants.each do |participant|
      participant = participant[:participant]
      transmit_key = "general_#{participant.class.name}_#{participant.id}"

      ActionCable.server.broadcast(transmit_key,
        type: 'NEW_CONVERSATION',
        conversation: conversation.id)
    end

    Admin.all.each do |admin|
      ActionCable.server.broadcast("general_Admin_#{admin.id}",
        type: 'NEW_CONVERSATION', conversation: conversation.id)
    end
  end
end
