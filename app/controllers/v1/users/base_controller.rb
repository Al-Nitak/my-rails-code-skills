# frozen_string_literal: true

class V1::Users::BaseController < ApplicationController
  include ActionController::MimeResponds
  before_action :authenticate_user!
  before_action :update_auth_header
  before_action :ensure_profile_completion

  def ensure_profile_completion
    return if current_user.is_profile_completed?

    render(
      json: {
        response_code: ResponseCodes::PROFILE_NOT_COMPLETED,
        message: I18n.t('controllers.v1.users.base.complete_profile').to_s,
      },
      status: :unauthorized
    )
  end
end
