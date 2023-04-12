# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { "admin_#{SecureRandom.hex}@example.com" }
    password { 'password' }
    factory :confirmed_admin do
      confirmed_at { Time.zone.now }
      confirmation_token { 'confirmationToken' }
      reset_password_token { 'resetPassword' }
    end
  end
end
