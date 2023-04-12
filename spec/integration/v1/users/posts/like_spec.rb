# frozen_string_literal: true

require('swagger_helper')

describe 'Post Like Users API' do
  let(:user) { create(:confirmed_user) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:post_like) { create(:post_like, user: user) }
  let(:posting) { create(:post) }

  before do
    post_like
  end

  path '/v1/users/posts/likes' do
    post 'Like a Post' do
      tags 'User-PostLike'
      consumes 'multipart/form-data'
      parameter name: 'post_like[post_id]', in: :formData, type: :string, required: true

      response '201', 'Post created' do
        let('post_like[post_id]') { posting[:id] }

        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '422', 'Invalid params' do
        let('post_like[post_id]') { nil }

        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '401', 'user not signed in' do
        let('post_like[post_id]') { posting[:id] }

        let(:client) {}
        let(:token) {}
        let(:uid) {}
        run_test!
      end
    end
  end

  path '/v1/users/posts/likes/{id}' do
    parameter name: :id, in: :path, required: true,
    descrtiption: 'post id'
    delete 'Delete a certain Post Like' do
      tags 'User-Posts'
      produces 'application/json'

      response '200', 'PostLike deleted' do
        let(:id) { post_like.post[:id] }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '404', 'PostLike not found' do
        let(:id) { 'whoami' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end
end
