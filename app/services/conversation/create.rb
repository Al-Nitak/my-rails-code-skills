# frozen_string_literal: true

class Conversation::Create
  include Interactor
  delegate :fail!, to: :context

  def call
    conversation = Conversation.new
    fail!(errors: conversation.errors) unless conversation.save
    context.conversation = conversation
  end
end
