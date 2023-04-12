# frozen_string_literal: true

require('rails_helper')

RSpec.describe(V1::Users::Users::LikesController, type: :controller) do
  let(:user) { sign_in_user }
  let(:liked_user) { create(:user) }

  let(:user_like) { create(:user_like, source: user, target_id: liked_user.id) }

  let(:valid_attributes) do
    attributes_for(:user_like,
      target_id: liked_user.id, source_id: user.id)
  end

  let(:valid_super_like_attributes) do
    attributes_for(:user_like, :super_like,
      target_id: liked_user.id, source_id: user.id)
  end

  let(:invalid_attributes) { attributes_for(:user_like, :invalid) }

  let(:connection) { create(:connection, :with_users, user1: user, user2: liked_user) }

  before do
    user
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User Like ' do
        post :create, params: { user_like: valid_attributes }
        expect { to(change(UserLike, :count).by(1)) }
      end

      it 'renders a JSON response with the new user like' do
        post :create, params: { user_like: valid_attributes }
        expect(response).to(have_http_status(:created))
      end
    end

    context 'with valid params after creating exceeding likes limit' do
      before do
        create_list(:user_like, 10, source: user)
      end
      it 'renders a JSON response with errors for the user like' do
        post :create, params: { user_like: valid_attributes }
        expect(response).to(have_http_status(:unprocessable_entity))
        expect(json[:like_type]).to be_present
      end
    end

    context 'with valid params after exceeding super likes limit' do
      before do
        create(:user_like, :super_like, source: user)
      end
      it 'renders a JSON response with errors for the user like' do
        post :create, params: { user_like: valid_super_like_attributes }
        expect(response).to(have_http_status(:unprocessable_entity))
        expect(json[:like_type]).to be_present
      end
    end
    context 'with valid params after creating the same like' do
      before do
        user_like
      end
      it 'renders a JSON response with errors for the user like' do
        post :create, params: { user_like: valid_attributes }
        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the user like' do
        post :create, params: { user_like: invalid_attributes }
        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      user_like
    end
    context 'when deleting user like that has no connection' do
      it 'destroys the requested User Like' do
        delete :destroy
        expect { to(change(UserLike, :count).by(-1)) }
      end
    end

    context 'when deleting user like that has connection' do
      before do
        connection
      end
      it 'return the correct errors' do
        delete :destroy
        expect(response).to(have_http_status(:unprocessable_entity))
        expect(json[:connection]).to be_present
      end
    end

    context 'when deleting user like after exceeding undo limits' do
      before do
        create(:undo, user: user)
      end
      it 'return the correct errors' do
        delete :destroy
        expect(response).to(have_http_status(:unprocessable_entity))
        expect(json[:undo]).to be_present
      end
    end
    context 'when trying to delete user like that is not found' do
      before do
        UserLike.destroy_all
      end
      it 'return not found' do
        delete :destroy
        expect(response).to(have_http_status(:not_found))
      end
    end
  end
end
