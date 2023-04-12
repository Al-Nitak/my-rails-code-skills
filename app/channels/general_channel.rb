# frozen_string_literal: true

class GeneralChannel < ApplicationCable::Channel
  def subscribed
    key = generate_transmit_key
    stream_from(key)
  end

  def unsubscribed
  end

  private

  def generate_transmit_key
    "general_#{current_user.class.name}_#{current_user.id}"
  end
end
