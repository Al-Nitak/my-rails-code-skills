# frozen_string_literal: true

class Connections::Organizers::Delete
  include Interactor::Organizer

  organize Connections::Delete
end
