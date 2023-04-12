# frozen_string_literal: true

class Conversation::ConstructMessage
  include Interactor
  delegate :message_params, :conversation, :sender, :fail!, to: :context

  def call
    message = conversation.messages.new(message_params)
    message.sender = sender

    fail!(errors: message.errors) unless message.save

    serailized_message = { message: MessageSerializer.new(message) }
    context.message = serailized_message
  end
end
