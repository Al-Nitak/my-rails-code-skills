# frozen_string_literal: true

require 'swagger_helper'

describe 'Users API' do
  let(:confirmed_user) { create(:confirmed_user) }
  let(:auth_headers) { confirmed_user.create_new_auth_token }
  let(:user) { create(:user) }

  path '/v1/users/users/self' do
    get 'Retrieves user profile ' do
      tags 'User-Users'
      response '200', 'Profile retrieved' do
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end
      response '401', 'user is not authorized' do
        let(:client) {}
        let(:token) {}
        let(:uid) {}
        run_test!
      end
    end
  end

  path '/v1/users/users/{id}' do
    get 'Retrieves a specific user profile by ID' do
      tags 'User-Users'
      parameter name: :id, in: :path
      response '200', 'Profile retrieved' do
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        let(:id) { user.id }
        run_test!
      end
    end
  end

  path '/v1/users/users' do
    get 'Retrieve Matching Users' do
      tags 'User-Users'
      produces 'application/json'
      parameter name: :page, in: :query, type: :string
      parameter name: :per_page, in: :query, type: :string
      # response '200', 'success' do
      #   let(:page) { '1' }
      #   let(:per_page) { '10' }
      #   let(:client) { auth_headers['client'] }
      #   let(:token) { auth_headers['token'] }
      #   let(:uid) { auth_headers['uid'] }
      #   let(:gender) { 'male' }
      #   let(:query) { 'user' }
      #   run_test!
      # end

      response '401', 'user is not authorized' do
        let(:page) {}
        let(:per_page) {}
        let(:client) {}
        let(:token) {}
        let(:uid) {}
        let(:gender) {}
        let(:query) {}
        run_test!
      end
    end

    delete 'Delete current user' do
      tags 'User-Users'
      produces 'application/json'
      response '200', 'success' do
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        run_test!
      end

      response '401', 'user is not authorized' do
        let(:client) {}
        let(:token) {}
        let(:uid) {}
        run_test!
      end
    end

    put 'Updates user profile' do
      tags 'User-Users'
      consumes 'application/json'
      parameter name: :user,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    phone_number: { type: :string },
                    date_of_birth: { type: :string },
                    country: { type: :string },
                    bio: { type: :string },
                    education: { type: :enum, enum: %i(student bachelor master doctorate) },
                    major: { type: :string },
                    occupation: { type: :string },
                    company: { type: :string },
                    networking_drink: { type: :string },
                    super_hero: { type: :string },
                    profile_picture: { type: :string },
                    word_description: { type: :string },
                    network_guided: { type: :boolean },
                    news_feed_guided: { type: :boolean },
                    matching_radius: { type: :string },
                    university_id: { type: :string },
                  },
                }
      response '200', 'User udpated' do
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        let(:user) do
          {
            user: {
              name: 'test user',
              phone_number: '01068966844',
              date_of_birth: '31/3/1998',
              gender: 'male',
              bio: 'updated bio',
              matching_radius: 5,

            },
          }
        end
        run_test!
      end
      response '422', 'Invalid params' do
        let(:client) { auth_headers['client'] }
        let(:token) { auth_headers['token'] }
        let(:uid) { auth_headers['uid'] }
        let(:user) do
          {
            user: {
              name: 'test user',
              phone_number: '01068966844',
              date_of_birth: '31/3/1998',
              gender: 'male',
              bio: 'updated bio',
              word_description: 'two words',
            },
          }
        end
        run_test!
      end
    end
  end
end
