# frozen_string_literal: true

class Conversation::FcmNotify
  include Interactor
  delegate :conversation, :message, :sender, to: :context

  def call
    conversation_message = message[:message].object
    conversation.conversation_participants.each do |conversation_participant|
      participant = conversation_participant.participant
      next unless participant.id != sender.id
      content = conversation_message.body || 'sent an attachment'
      FcmJob.perform_later(participant.id,
        title: 'Message Received',
        body: "#{sender.name}: #{content}")
      UserNotifications.new(user_id:participant.id,
                            notification_text:"You received a message from #{sender.name}",
                            source_user_id: sender.id).save
    end
  end
end
