
# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'user' }
    email { "user_#{SecureRandom.hex}@example.com" }
    password { 'password' }
    gender { 'male' }
    country { 'egypt' }
    matching_radius { 8.04672 }
    country_code { '+20' }
    lat { '30' }
    lng { '30' }
    profile_picture { uploaded_image }
    sequence(:phone_number) { |n| "01#{(100_000_000 + n)}" }
    date_of_birth { '3/3/2000' }

    trait :with_invalid_date do
      date_of_birth { 'invalid' }
      profile_picture { nil }
    end
    trait :without_image do
      profile_picture { nil }
    end
    trait :near do
      lat { '30.01' }
      lng { '29.97' }
    end
    trait :far do
      lat { '30.02' }
      lng { '29.95' }
    end

    trait :with_max_answers do
      answers { create_list(:answer, 3) }
    end

    trait :farther do
      lat { '30.04' }
      lng { '29.94' }
    end
    trait :out_of_range do
      lat { '27.101370484718142' }
      lng { '27.101370484718142' }
    end
    trait :with_confirmation_otp do
      sequence(:confirmation_otp) { |n| "#{n}otp " }
      confirmation_otp_sent_at { Time.zone.now - 1.days }
    end

    trait :invalid_to_request_otp do
      sequence(:confirmation_otp) { |n| "#{n}otp " }
      confirmation_otp_sent_at { Time.zone.now }
    end

    trait :reached_max_otp_per_day do
      sequence(:confirmation_otp) { |n| "#{n}otp " }
      confirmation_otp_sent_at { Time.zone.now - 4.minutes }
      otps_sent_today { 5 }
    end

    trait :reached_max_otp_another_day do
      sequence(:confirmation_otp) { |n| "#{n}otp " }
      confirmation_otp_sent_at { Time.zone.now - 1.days }
      otps_sent_today { 5 }
    end

    trait :with_password_reset_otp do
      sequence(:confirmation_otp) { |n| "#{n}otp " }
      password_reset_otp_sent_at { Time.zone.now }
    end

    trait :with_long_word_description do
      word_description { 'long description' }
    end

    trait :with_complete_profile_attributes do
      bio { 'bio' }
      major { 'major' }
      education { :student }
      occupation { 'occupation' }
      university
      profile_picture { upload_image }
    end

    trait :with_invalid_phone_number do
      phone_number { '123' }
    end
    trait :with_post_like do
      post_likes { create_list(:post_like, 1) }
    end

    trait :with_post_comment do
      post_comments { create_list(:post_comment, 1) }
    end

    factory :confirmed_user do
      confirmed_at { Time.zone.now }
      is_profile_completed { true }
      profile_picture { uploaded_image }
    end

    factory :female_user do
      gender { 'female' }
    end
  end
end
