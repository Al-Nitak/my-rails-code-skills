# frozen_string_literal: true

class V1::Users::Posts::LikesController < V1::Users::BaseController
  before_action :set_like, only: [:destroy]

  def create
    @like = current_user.post_likes.new(post_like_params)

    if @like.save
      render json: @like.post, status: :created, user_id: current_user.id
      FcmJob.perform_later(@like.post.author.id,
        title: 'Post Like',
        body: "#{current_user.name} liked your post")
      UserNotification.new(user_id:@like.post.author.id,
                           notification_text:"#{current_user.name} liked your post",
                           post_id: @like.post.id,
                           source_user_id: current_user.id).save
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @like.destroy
    render json: @like.post, status: :ok, user_id: current_user.id
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_like
    @like = current_user.post_likes.find_by_post_id!(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_like_params
    params.require(:post_like).permit(:post_id)
  end
end
