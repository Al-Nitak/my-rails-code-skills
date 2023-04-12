# frozen_string_literal: true

module Transactionable
  extend ActiveSupport::Concern

  included do
    def call
      ActiveRecord::Base.transaction do
        super
      end
    end
  end
end
