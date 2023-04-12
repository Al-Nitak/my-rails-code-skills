# frozen_string_literal: true

class V1::Admin::ConversationsController < V1::Admin::BaseController
  before_action :set_conversation, only: [:show, :update]

  # GET /conversations
  def index
    @conversations = Conversation.all
    @conversations = @conversations.search(params[:query], current_admin) if params[:query].present?
    @conversations = @conversations.ordered_descendingly
    paginate(collection: @conversations, render_options: { current_participant: current_admin })
  end

  # GET /conversations/1
  def show
    render(json: @conversation, current_participant: current_admin)
  end

  # UPDATE /conversations/id -- Updates the last timestamp a user appeared in a conversation.
  def update
    head(:ok)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_conversation
    @conversation = Conversation.find(params[:id])
  end
end
