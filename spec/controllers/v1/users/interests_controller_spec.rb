# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::Users::InterestsController, type: :controller) do
  let(:confirmed_user) do
    create(:confirmed_user)
  end

  let(:user_interest) { create(:user_interest, user: confirmed_user) }
  let(:other_user_interest) { create(:user_interest) }
  let(:interest) { create(:interest) }
  let(:main_category) { create(:main_category) }
  let(:valid_user_interest_params) { attributes_for(:interest, id: interest.id) }
  let(:repeated_interest_params) { attributes_for(:interest, id: user_interest.interest_id) }
  let(:invalid_user_interest_params) { attributes_for(:interest, id: main_category.id) }

  before { sign_in_user(confirmed_user) }

  describe 'Get #index' do
    before { user_interest }
    context 'when retrieving all user interests' do
      it 'returns the user interests' do
        get :index
        expect(json[:interests].count).to eq(1)
      end
    end
  end

  describe 'Post #create' do
    context 'when adding a valid interest' do
      it 'adds it to the current user interests' do
        post :create, params: { interest: valid_user_interest_params }
        expect(json[:user_interest][:interest][:id]).to eq(interest.id)
        expect { to(change(UserInterest, :count).by(1)) }
      end
    end
    context 'when adding an already added interest' do
      it 'fails to add' do
        post :create, params: { interest: repeated_interest_params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:user_id]).to be_truthy
      end
    end
    context 'when adding a main category as an interest' do
      before { main_category }
      it 'fails to add' do
        post :create, params: { interest: invalid_user_interest_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'Delete #destroy' do
    context 'when deleting a user interest'
    it 'deletes it from the current user interests' do
      delete :destroy, params: { id: user_interest.interest.id }
      expect { to(change(UserInterest, :count).by(-1)) }
      expect { to(change(Label, :count).by(0)) }
    end
    context 'when deleting a a user interest belonging to another user' do
      it 'returns not found' do
        delete :destroy, params: { id: other_user_interest.id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
