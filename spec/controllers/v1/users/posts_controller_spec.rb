# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::Users::PostsController, type: :controller) do
  let(:valid_post_attributes) { attributes_for(:post, :with_post_topic) }
  let(:confirmed_user) { create(:confirmed_user) }
  let(:invalid_post_attributes) do
    attributes_for(:post, :invalid)
  end

  let(:connection) do
    create(:connection, :with_users, user1: confirmed_user)
  end
  let(:posts) { create_list(:post, 2) }
  let(:topic) { create(:post_topic) }
  let(:posting) { create(:post, post_topic: topic) }
  let(:connection_post) { create(:post, user_id: confirmed_user.id) }
  before { sign_in_user(confirmed_user) }

  describe 'Post #create' do
    context 'when creating with valid params' do
      it 'creates a post with the correct params and increments the database count by 1' do
        post :create, params: { post: valid_post_attributes }
        expect(response).to be_successful
        expect(json[:post][:text]).to eq(valid_post_attributes[:text])
        expect(json[:post][:author][:id]).to eq(confirmed_user.id)
      end
    end

    context 'when creating with invalid params' do
      it 'fails to create' do
        post :create, params: { post: invalid_post_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'Get #index' do
    before { posts }
    context 'fetching all data' do
      it 'returns correct posts count' do
        get :index
        expect(json[:posts].count).to eq(2)
      end
    end
    context 'when searching and filtering' do
      before do
        connection_post
        connection
        topic
        posting
      end
      it 'returns no results for filtering another type' do
        get :index, params: { topic: topic.id }
        expect(json[:posts].count).to eq(1)
      end
      it 'returns all results for filtering the same type' do
        get :index, params: { connections_posts: true }
        expect(json[:posts].count).to eq(1)
      end
    end
  end
end
