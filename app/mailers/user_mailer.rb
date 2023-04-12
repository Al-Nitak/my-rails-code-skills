# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_user_invitation_instructions(user)
    @user = user
    mail(to: @user.email, subject: 'Your account confirmation instructions')
  end

  def send_user_confirmation_link(user)
    @user = user
    mail(to: @user.email, subject: 'Your account confirmation link')
  end

  def send_account_confirmation_notification(user)
    @user = user
    mail(to: @user.email, subject: 'Your account has been confirmed')
  end

  def send_password_reset_token(user)
    @user = user
    mail(to: @user.email, subject: 'Your password reset token')
  end
end
