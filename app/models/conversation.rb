# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :conversation_participants, dependent: :destroy
  has_many :users, source_type: :User, through: :conversation_participants, source: :participant
  has_many :messages, dependent: :destroy

  accepts_nested_attributes_for :conversation_participants

  scope :ordered_descendingly, -> () {
    select('conversations.*, COALESCE(MAX(messages.created_at), conversations.created_at)
    AS max_timestamp')
      .left_outer_joins(:messages).group('conversations.id')
      .order('max_timestamp': :desc)
  }

  scope :search, -> (query, current_user) {
    joins(:users)
      .where("users.name LIKE '%#{query}%' AND users.id <> #{current_user.id}")
      .distinct
  }

  def last_message
    messages.order(created_at: :desc).first
  end

  def calculate_unread_count(namespace, current_participant)
    messages
      .where("conversation_participants.conversation_id = #{id}
            AND conversation_participants.participant_type = '#{namespace}'
            AND conversation_participants.participant_id = #{current_participant.id}")
      .joins("INNER JOIN conversation_participants ON
            messages.created_at > conversation_participants.last_appearance
            OR conversation_participants.last_appearance IS NULL")
      .count
  end
end
