# frozen_string_literal: true

class DeleteUserJob < ApplicationJob
  def perform(user_id)
    user = User.find_by_id(user_id)
    Users::Delete.call(user: user) if user.present?
  end
end
