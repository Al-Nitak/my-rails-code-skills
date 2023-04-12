# frozen_string_literal: true

class SmsJob < ApplicationJob
  def perform(message, phone_number)
    SmsHandler.new(message, phone_number).send
  end
end
