# frozen_string_literal: true

class V1::Users::Posts::CommentsController < V1::Users::BaseController
  before_action :set_comment, only: [:destroy]

  def create
    result = Posts::Organizers::Comment.call(
      current_user: current_user,
      post_comment: post_comment_params,
      tagged_users: params[:tagged_users]
    )
    if result.success?
      render json: result.comment, status: :created
    else
      render json: result.errors, status: :unprocessable_entity
    end

  end

  def destroy
    @comment.destroy
    render json: @comment.post, status: :ok, user_id: current_user.id
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = current_user.post_comments.find_by_id!(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_comment_params
    params.require(:post_comment).permit(:post_id, :text)
  end
end
