# frozen_string_literal: true

class DeleteConnectionJob < ApplicationJob
  def perform(connection_id)
    connection = Connection.find_by_id(connection_id)
    Connections::Organizers::Delete.call(connection: connection) if connection.present? && connection.messages.count > 0
  end
end
