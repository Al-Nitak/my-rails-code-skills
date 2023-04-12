# frozen_string_literal: true

FactoryBot.define do
  factory :connection do
    trait :with_users do
      transient do
        user1 { user1 }
        user2 { create(:user) }
      end
      connection_users_attributes do
        [
          { user: user1 },
          { user: user2 },
        ]
      end
    end
  end
end
