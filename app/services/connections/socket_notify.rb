# frozen_string_literal: true

class Connections::SocketNotify
  include Interactor
  delegate :user_like_with_match, to: :context

  def call
    return unless user_like_with_match.present?

    serialized_user_like = UserLikeSerializer.new(user_like_with_match)
    target = user_like_with_match.target
    transmit_key = "general_#{target.class.name}_#{target.id}"

    ActionCable.server.broadcast(transmit_key,
      type: 'NEW_CONNECTION',
      user_like: serialized_user_like)
  end
end
