# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      provider = request.params[:provider] || 'user'
      user = provider.classify.constantize.find_by_uid(request.params[:uid])
      if user&.valid_token?(request.params[:token], request.params[:client])
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
