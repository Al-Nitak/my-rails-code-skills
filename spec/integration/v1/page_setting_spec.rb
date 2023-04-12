# frozen_string_literal: true

require 'swagger_helper'

describe 'PageSetting API' do
  path '/v1/page_settings' do
    get 'Retrieves all page_settings for web' do
      tags 'PageSetting'
      produces 'application/json'

      let(:admin) { create(:confirmed_admin) }
      let(:auth_headers) { admin.create_new_auth_token }
      response '200', 'PageSetting' do
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end

  path '/v1/page_settings/{id}' do
    get 'Retrieves all page_settings for web' do
      tags 'PageSetting'
      produces 'application/json'
      parameter name: :id, in: :path

      let(:admin) { create(:confirmed_admin) }
      let(:auth_headers) { admin.create_new_auth_token }
      let(:page_setting) { create(:page_setting) }
      response '200', 'PageSetting' do
        let(:id) { page_setting.id }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end
end
