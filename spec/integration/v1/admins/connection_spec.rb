# frozen_string_literal: true

require('swagger_helper')

describe 'Connection Admins API' do
  let(:admin) { create(:confirmed_admin) }
  let(:auth_headers) { admin.create_new_auth_token }
  let(:connection) { create(:connection) }

  before do
    connection
  end

  path '/v1/admin/connections' do
    get 'Retrieves connections' do
      tags 'Admin-Connections'
      produces 'application/json'
      parameter name: :page, in: :query, type: :string
      parameter name: :per_page, in: :query, type: :string

      response '200', 'Connections fetched' do
        let(:page) { '1' }
        let(:per_page) { '10' }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end

  path '/v1/admin/connections/{id}' do
    parameter name: :id, in: :path, required: true
    get 'Gets a certain connection' do
      tags 'Admin-Connections'
      produces 'application/json'

      response '200', 'Connection fetched' do
        let(:id) { connection[:id] }
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '404', 'Connection not found' do
        let(:id) { 'whoami' }
        let(:student_id) {}
        let(:group_id) {}
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
    end
  end
end
