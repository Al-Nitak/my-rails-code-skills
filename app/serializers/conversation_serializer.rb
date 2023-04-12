# frozen_string_literal: true

class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :last_message, :unread_count
  has_many :conversation_participants

  def last_message
    MessageSerializer.new(object.last_message).as_json if object.last_message.present?
  end

  def unread_count
    current_participant = @instance_options[:current_participant]
    namespace = @instance_options[:namespace]
    object.calculate_unread_count(namespace, current_participant)
  end
end
