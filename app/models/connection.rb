# frozen_string_literal: true

class Connection < ApplicationRecord
  has_many :connection_users, dependent: :destroy
  belongs_to :conversation, dependent: :destroy, optional: true
  has_many :messages, through: :conversation
  accepts_nested_attributes_for :connection_users

  validate :cannot_have_more_than_two_users

  def cannot_have_more_than_two_users
    errors.add(:connection, I18n.t(
      'models.errors.messages.cannot_has_more_than_two_users'
    ).to_s) if connection_users.count > 2
  end
end
