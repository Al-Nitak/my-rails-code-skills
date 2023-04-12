# frozen_string_literal: true

class Connections::FcmNotify
  include Interactor
  delegate :user_like, :participants, to: :context

  def call
    return unless participants.present?
    UserNotifications.new(user_id:user_like.target.id,
                         notification_text:"You are now connected to #{user_like.source.name}",
                           source_user_id: user_like.source.id).save
    UserNotifications.new(user_id:user_like.source.id,
                          notification_text:"You are now connected to #{user_like.source.name}",
                           source_user_id: user_like.target.id).save
    FcmJob.perform_later(user_like.target.id,
      title: 'Match Found',
      body: "You are now connected to #{user_like.source.name}")

    FcmJob.perform_later(user_like.source.id,
      title: 'Match Found',
      body: "You are now connected to #{user_like.target.name}")
  end
end
