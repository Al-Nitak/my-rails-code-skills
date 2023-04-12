# frozen_string_literal: true

require('swagger_helper')

describe 'Post Comment Users API' do
  let(:user) { create(:confirmed_user) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:post_comment) { create(:post_comment, user: user, text: 'text') }
  let(:posting) { create(:post) }

  path '/v1/users/posts/comments' do
    post 'comment on  a Post' do
      tags 'User-PostComment'
      consumes 'multipart/form-data'
      parameter name: 'post_comment[post_id]', in: :formData, type: :number, required: true
      parameter name: 'post_comment[text]', in: :formData, type: :string, required: true
      response '201', 'Post created' do
        let('post_comment[post_id]') { posting[:id] }
        let('post_comment[text]') { 'comment text' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '422', 'Invalid params' do
        let('post_comment[post_id]') { nil }
        let('post_comment[text]') { nil }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '401', 'user not signed in' do
        let('post_comment[post_id]') { posting[:id] }
        let('post_comment[text]') { 'comment text' }

        let(:client) {}
        let(:token) {}
        let(:uid) {}
        run_test!
      end
    end
  end

  path '/v1/users/posts/comments/{id}' do
    parameter name: :id, in: :path, required: true,
    descrtiption: 'post id'
    delete 'Delete a certain Post comment' do
      produces 'application/json'

      response '200', 'PostComment deleted' do
        let(:id) { post_comment.post[:id] }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '404', 'PostComment not found' do
        let(:id) { 'whoami' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end
end
