# frozen_string_literal: true

class ConnectionSerializer < ActiveModel::Serializer
  attributes :id, :created_at
  has_many :connection_users
end
class ConnectionUserSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name
  belongs_to :user
  def name
    object.user.name
  end
end
