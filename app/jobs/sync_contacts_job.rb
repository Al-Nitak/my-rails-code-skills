# frozen_string_literal: true

class SyncContactsJob < ApplicationJob
  def perform(numbers, current_user_id)
    return unless numbers.present?

    current_user = User.find_by_id(current_user_id)
    return unless current_user.present?

    numbers.each do |number|
      potential_connection_user = User.find_by_phone_number(number.delete(' '))
      next if potential_connection_user.nil? || current_user.matched_with?(potential_connection_user.id)

      Connections::Organizers::SyncContacts.call(users: [current_user, potential_connection_user])
    end
  end
end
