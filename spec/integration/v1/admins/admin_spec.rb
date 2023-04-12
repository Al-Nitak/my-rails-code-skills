# frozen_string_literal: true

require 'swagger_helper'

describe 'Admins API' do
  path '/v1/admin/admins' do
    post 'Creates Admin' do
      tags 'Admins'
      consumes 'multipart/form-data'
      parameter name: 'admin[email]', in: :formData

      let(:auth_headers) { create(:confirmed_admin).create_new_auth_token }
      response '201', 'Admin created' do
        let('admin[email]') { 'valid@email.com' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '422', 'invalid attributes' do
        let('admin[email]') { 'invalid' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end

  path '/v1/admins/sign_in' do
    post 'Authenticate an Admin' do
      tags 'Admins'
      consumes 'application/json'
      parameter name: :admin,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    email: { type: :string }, password: { type: :string }
                  },
                  required: %w(email password),
                }
      let(:confirmed_admin) { create(:confirmed_admin) }
      response '200', 'Admin Authenticated' do
        let(:admin) { { email: confirmed_admin.email, password: 'password' } }
        let(:client) {}
        let(:token) {}
        let(:uid) {}
        run_test!
      end

      response '401', 'wrong email or password' do
        let(:admin) do
          { email: 'invalid@email.com', password: 'invalidPassword' }
        end
        let(:client) {}
        let(:token) {}
        let(:uid) {}
        run_test!
      end
    end
  end

  path '/v1/admin/admins/{id}' do
    put 'Edit an Admin' do
      tags 'Admins'
      consumes 'multipart/form-data'
      parameter name: 'admin[name]', in: :formData
      parameter name: :id, in: :path

      let(:confirmed_admin) { create(:confirmed_admin) }
      let(:auth_headers) { confirmed_admin.create_new_auth_token }
      response '200', 'Admin Edited successfully' do
        let('admin[name]') { 'validName' }
        let(:id) { confirmed_admin.id }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '401', 'Admin is not logged in' do
        let('admin[name]') { 'ahmed' }
        let(:id) { confirmed_admin.id }
        let(:client) {}
        let(:token) {}
        let(:uid) {}
        run_test!
      end
    end
  end

  path '/v1/admin/confirmations' do
    put 'Complete Admin registration by confirmation token' do
      tags 'Admins'
      consumes 'multipart/form-data'
      parameter name: :confirmation_token, in: :query, type: :string
      parameter name: 'admin[password]', in: :formData
      parameter name: 'admin[password_confirmation]', in: :formData

      let(:confirmed_admin) { create(:confirmed_admin) }
      let(:auth_headers) { confirmed_admin.create_new_auth_token }
      response '201', 'Admin created' do
        let(:confirmation_token) { confirmed_admin.confirmation_token }
        let('admin[password]') { 'passwordd' }
        let('admin[password_confirmation]') { 'passwordd' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '422', 'invalid request' do
        let(:confirmation_token) { confirmed_admin.confirmation_token }
        let('admin[password]') { 'passwordd' }
        let('admin[password_confirmation]') { 'passwd' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end

  path '/v1/admin/confirmations' do
    post 'Send confirmation instructions to a admin' do
      tags 'Admins'
      consumes 'application/json'
      parameter name: :email, in: :query, type: :string

      let(:confirmed_admin) { create(:confirmed_admin) }
      let(:auth_headers) { confirmed_admin.create_new_auth_token }

      response '200', 'email sent' do
        let(:email) { confirmed_admin.email }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '404', 'not found' do
        let(:email) { 'notExisting@email.com' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end

  path '/v1/admin/passwords' do
    put 'Change password' do
      tags 'Admins'
      consumes 'multipart/form-data'
      parameter name: :reset_password_token, in: :query, type: :string
      parameter name: 'password', in: :formData
      parameter name: 'password_confirmation', in: :formData

      let(:confirmed_admin) { create(:confirmed_admin) }
      let(:auth_headers) { confirmed_admin.create_new_auth_token }
      response '200', 'Change password success' do
        let(:reset_password_token) { confirmed_admin.reset_password_token }
        let(:password) { 'Passwordd' }
        let(:password_confirmation) { 'Passwordd' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '422', 'invalid request' do
        let(:reset_password_token) { confirmed_admin.reset_password_token }
        let(:password) { 'Passworddddd' }
        let(:password_confirmation) { 'Passwordd' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end

  path '/v1/admin/passwords' do
    post 'Send forget a password instructions' do
      tags 'Admins'
      consumes 'application/json'
      parameter name: :email, in: :query, type: :string

      let(:confirmed_admin) { create(:confirmed_admin) }
      let(:auth_headers) { confirmed_admin.create_new_auth_token }
      response '200', 'forget password instructions sent' do
        let(:email) { confirmed_admin.email }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '404', 'email not found' do
        let(:email) { 'invalid@email.com' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end
end
