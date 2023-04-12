# frozen_string_literal: true

class Connections::Delete
  include Interactor
  delegate :connection, :fail!, to: :context
  def call
    connection.destroy
  end
end
