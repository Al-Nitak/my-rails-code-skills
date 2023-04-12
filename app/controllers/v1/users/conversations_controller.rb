# frozen_string_literal: true

class V1::Users::ConversationsController < V1::Users::BaseController
  before_action :set_conversation, only: [:show, :update]

  # GET /conversations
  def index
    @conversations = current_user.conversations
    @conversations = @conversations.search(params[:query], current_user) if params[:query].present?
    @conversations = @conversations.ordered_descendingly
    paginate(collection: @conversations, render_options: { current_participant: current_user })
  end

  # GET /conversations/1
  def show
    render(json: @conversation, current_participant: current_user)
  end

  # UPDATE /conversations/id -- Updates the last timestamp a user appeared in a conversation.
  def update
    participant_record = @conversation.conversation_participants.find_by!(participant: current_user)

    participant_record.update_column(:last_appearance, Time.now)
    head(:ok)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end
end
