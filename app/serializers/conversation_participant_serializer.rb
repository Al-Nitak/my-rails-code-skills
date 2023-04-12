# frozen_string_literal: true

class ConversationParticipantSerializer < ActiveModel::Serializer
  attributes :participant, :participant_type, :last_appearance
  attribute :created_at, key: :joined_at

  def participant
    ActiveModelSerializers::SerializableResource.new(
      object.participant, each_serializer: UserSerializer, adapter: :attributes
    )
  end
end
