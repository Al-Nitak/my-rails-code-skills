# frozen_string_literal: true

class Conversation::Organizers::SendMessage
  include Interactor::Organizer

  organize Conversation::ConstructMessage, Conversation::TransmitMessage, Conversation::FcmNotify
end
