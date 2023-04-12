# frozen_string_literal: true

class V1::Users::Users::LikesController < V1::Users::BaseController
  before_action :set_like, only: [:destroy]

  # POST /user_likes
  def create
    result = UserLikes::Organizers::Create.call(
      user: current_user,
      user_like_params: user_like_params
    )
    if result.success?
      render json: result.user_like, status: :created
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_likes/1
  def destroy
    result = UserLikes::Organizers::Undo.call(user_like: @like, user: current_user)
    if result.success?
      @like.destroy
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  private

  def set_like
    @like = current_user.liked.last
    raise ActiveRecord::RecordNotFound unless @like.present?
  end

  # Only allow a trusted parameter "white list" through.
  def user_like_params
    params.require(:user_like).permit(:target_id, :like_type)
  end
end
