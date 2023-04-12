# frozen_string_literal: true

require('rails_helper')
require('sidekiq/testing')

RSpec.describe(V1::Users::Users::SyncContactsController, type: :controller) do
  let(:user) { sign_in_user }
  let(:potential_user) { create(:user, phone_number: '+201063961597') }

  before do
    user
    potential_user
  end

  describe 'POST #create' do
    context 'When calling with valid phone numbers' do
      it 'creates a connection with existing phone numbers only' do
        Sidekiq::Testing.inline! do
          expect { post :create, params: { numbers: ['+201063961597', '+201063961598'] } }
            .to change(Connection, :count).by(1)
          expect(user.matched_with?(potential_user.id)).to(be true)
        end
      end
    end
  end
end
