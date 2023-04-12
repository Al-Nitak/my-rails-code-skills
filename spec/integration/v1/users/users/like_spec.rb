# frozen_string_literal: true

require('swagger_helper')

describe 'User Likes API' do
  let(:user) { create(:confirmed_user) }
  let(:liked_user) { create(:user) }

  let(:auth_headers) { user.create_new_auth_token }
  let(:user_like) { create(:user_like, source: user) }

  before do
    user_like
    liked_user
  end

  path '/v1/users/users/likes' do
    post 'Create a User Like' do
      tags 'User-Like'
      consumes 'multipart/form-data'
      parameter name: 'user_like[target_id]', in: :formData, type: :string, required: true
      parameter name: 'user_like[like_type]', in: :formData, type: :string, required: true,
      enum: %i(like dislike super_like)
      response '201', 'User Like created' do
        let('user_like[target_id]') { liked_user[:id] }
        let('user_like[like_type]') { :like }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '422', 'Invalid params' do
        let('user_like[target_id]') { nil }
        let('user_like[like_type]') { :like }

        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '401', 'user not signed in' do
        let('user_like[target_id]') { liked_user.id }
        let('user_like[like_type]') { :like }

        let(:client) {}
        let(:token) {}
        let(:uid) {}
        run_test!
      end
    end
  end
  path '/v1/users/users/likes' do
    delete 'Undo Like' do
      tags 'User-Like'
      produces 'application/json'

      response '204', 'Like deleted' do
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end
end
