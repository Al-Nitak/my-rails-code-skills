# frozen_string_literal: true

class Connections::Organizers::SyncContacts
  include Interactor::Organizer
  include Transactionable

  organize Connections::CreateContactConnection,
    Conversation::JoinConversation,
    Conversation::NewConversationBroadcast
end
