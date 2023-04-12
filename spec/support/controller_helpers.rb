# frozen_string_literal: true

module ControllerHelpers
  def sign_in_admin(admin = create(:admin))
    if admin.nil?
      allow(request.env['warden']).to(
        receive(:authenticate!).and_throw(:warden, scope: :admin)
      )
      allow(controller).to(receive(:current_admin).and_return(nil))
    else
      allow(request.env['warden']).to(receive(:authenticate!).and_return(admin))
      allow(controller).to(receive(:current_admin).and_return(admin))
    end
  end

  def sign_in_user(user = create(:confirmed_user))
    if user.nil?
      allow(request.env['warden']).to(
        receive(:authenticate!).and_throw(:warden, scope: :user)
      )
      allow(controller).to(receive(:current_user).and_return(nil))
    else
      allow(request.env['warden']).to(receive(:authenticate!).and_return(user))
      allow(controller).to(receive(:current_user).and_return(user))
      user
    end
  end
end
