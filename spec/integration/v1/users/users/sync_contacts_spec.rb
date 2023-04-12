# frozen_string_literal: true

require('swagger_helper')

describe 'User Contact Syncing API' do
  let(:user) { create(:confirmed_user) }
  let(:auth_headers) { user.create_new_auth_token }

  path '/v1/users/users/sync_contacts' do
    post 'Sync contacts' do
      tags 'Contacts Sync'
      consumes 'application/json'
      parameter name: :numbers, in: :body, required: true,
      description: 'pass an array of numbers you want the signed in user to connect with.'

      response '200', 'User Like created' do
        let(:numbers) { { numbers: ['+201063961597', '+201063961598'] } }

        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '401', 'user not signed in' do
        let(:numbers) { { numbers: ['+201063961597', '+201063961598'] } }

        let(:client) {}
        let(:token) {}
        let(:uid) {}
        run_test!
      end
    end
  end
end
