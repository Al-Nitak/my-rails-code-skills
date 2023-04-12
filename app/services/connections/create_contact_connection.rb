# frozen_string_literal: true

class Connections::CreateContactConnection
  include Interactor
  delegate :users, :fail!, to: :context

  def call
    conversation = Conversation.new
    fail!(errors: conversation.errors) unless conversation.save
    context.conversation = conversation

    connection_attributes = {
      connection_users_attributes: [{ user: users.first }, { user: users.second }],
      conversation: conversation,
    }

    connection = Connection.new(connection_attributes)
    fail!(errors: connection.errors) unless connection.save
    participants = [{ participant: users.first }, { participant: users.second }]
    context.participants = participants
  end
end
