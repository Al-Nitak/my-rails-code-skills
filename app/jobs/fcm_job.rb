# frozen_string_literal: true

class FcmJob < ApplicationJob
  def perform(id, data)
    fcm_tokens = User.find_by_id(id)&.devices&.pluck(:fcm_token)
    FcmNotification.new(fcm_tokens, data).send if fcm_tokens
  end
end
