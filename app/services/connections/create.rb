# frozen_string_literal: true

class Connections::Create
  include Interactor
  delegate :user_like, :fail!, :conversation, to: :context
  def call
    # if likes match create connection
    return unless user_like.source.liked_by.pluck(:source_id).include?(user_like.target_id)
    return if user_like.like_type.eql?('dislike')

    conversation = Conversation.new
    fail!(errors: conversation.errors) unless conversation.save
    context.conversation = conversation

    users = [{ user: user_like.target }, { user: user_like.source }]

    connection_attributes = {
      connection_users_attributes: users,
      conversation: conversation,
    }

    connection = Connection.new(connection_attributes)
    fail!(errors: connection.errors) unless connection.save
    context.user_like_with_match = user_like

    participants = [{ participant: user_like.target }, { participant: user_like.source }]
    context.participants = participants
    # DeleteConnectionJob.set(wait: 2.days).perform_later(connection.id)
  end
end
