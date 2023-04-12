# frozen_string_literal: true
class ConversationParticipant < ApplicationRecord
  PARTICIPANT_TYPES = %w(User).freeze
  validates :participant_type, inclusion: { in: PARTICIPANT_TYPES }
  validates_uniqueness_of :participant_type, scope: [:participant_id, :conversation], case_sensitive: false,
  message: I18n.t('models.errors.conversation_participant.already_joined').to_s

  belongs_to :participant, polymorphic: true
  belongs_to :conversation

  scope :by_participant, ->(participant) { where(participant: participant) }

  validate :cannot_have_more_than_two_participants_in_one_conversation

  def cannot_have_more_than_two_participants_in_one_conversation
    errors.add(:conversation, I18n.t(
      'models.errors.messages.cannot_has_more_than_two_participants'
    ).to_s) if conversation.conversation_participants.count >= 2
  end
end
