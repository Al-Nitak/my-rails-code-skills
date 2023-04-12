# frozen_string_literal: true

class ConnectionUser < ApplicationRecord
  validates_uniqueness_of :user_id, scope: [:connection_id]
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :connection

  scope :by_user, ->(user_id) {
    where(user_id: user_id)
  }
end
