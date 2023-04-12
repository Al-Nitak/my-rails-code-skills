# frozen_string_literal: true

class V1::Users::ConfirmationsController < V1::Users::BaseController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_profile_completion
  def create
    user = User.find_by_phone_number!(params[:phone_number])
    if user.confirmed?
      render(
        json: {
          errors:
            I18n.t('controllers.v1.users.confirmations.already_confirmed').to_s,
        },
        status: :unprocessable_entity
      )
    else
      result = Users::SetConfirmationService.call(user: user)
      if result.success?
        user.send_welcome_email
        render(
          json: {
            remaining_otp: 5 - user.otps_sent_today,
            message:
              I18n.t('controllers.v1.users.confirmations.confirmation_otp_sent')
                .to_s,
          },
          status: :ok
        )
      else
        render(json: result.errors, status: :unprocessable_entity)
      end
    end
  end

  def update
    result = Users::ConfirmService.call(params)
    if result.success?
      render(json: result.user, status: :created)
    else
      render(json: result.errors, status: :unprocessable_entity)
    end
  end
end
