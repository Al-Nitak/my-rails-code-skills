# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostComment, type: :model do
  let(:postComment) { create(:post_comment) }

  describe 'validations' do
    it {
      should validate_presence_of(:text)
    }
  end
end
