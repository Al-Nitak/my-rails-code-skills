# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::Users::RegistrationsController, type: :controller) do
  let(:valid_user_attributes) { attributes_for(:user) }
  let(:invalid_user_attributes) do
    attributes_for(:user, :with_invalid_date, :with_long_word_description, :without_image)
  end
  let(:valid_complete_profile_attributes) do
    attributes_for(:user, :with_complete_profile_attributes)
  end
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'Post #create' do
    context 'when given valid params' do
      it 'creates the user with the correct phone number and creates a confirmation_otp' do
        post :create, params: { user: valid_user_attributes }
        expect(json[:user][:phone_number]).to eq(
          valid_user_attributes[:phone_number]
        )
        expect { to(change(User, :count).by(+1)) }
        user = User.find(json[:user][:id])
        expect(user.confirmation_otp).to be_present
      end
    end
    context 'when given invalid params' do
      it 'fails' do
        post :create, params: { user: invalid_user_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:date_of_birth]).to be_truthy
      end
    end
  end

  describe 'Put #update' do
    before { sign_in_user(create(:user, profile_picture: nil)) }
    context 'when given valid params' do
      it 'updates the user with the correct bio and completes the user profile' do
        put :update, params: { user: valid_complete_profile_attributes }
        expect(json[:user][:bio]).to eq(valid_complete_profile_attributes[:bio])
        user = User.find(json[:user][:id])
        expect(user.is_profile_completed).to eq(true)
      end
    end

    context 'when given invalid params' do
      it 'fails' do
        put :update, params: { user: invalid_user_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:date_of_birth]).to be_truthy
        expect(json[:word_description_length]).to be_truthy
        expect(json[:profile_picture]).to be_truthy
      end
    end
  end
end
