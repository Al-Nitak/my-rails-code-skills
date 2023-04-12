# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def send_admin_invitation_instructions(admin)
    @admin = admin
    mail(to: @admin.email, subject: 'Your account confirmation instructions')
  end

  def send_admin_password_reset_instructions(admin)
    @admin = admin
    mail(to: @admin.email, subject: 'Your password reset instructions')
  end
end
