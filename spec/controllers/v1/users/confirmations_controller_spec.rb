# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::Users::ConfirmationsController, type: :controller) do
  let(:user) { create(:user, :with_confirmation_otp) }
  let(:confirmed_user) { create(:confirmed_user) }

  describe 'Post #create' do
    context 'when confirming an unconfirmed user' do
      it 'sends a confirmation otp' do
        post :create, params: { phone_number: user.phone_number }
        expect(response).to be_successful
      end
    end
    context 'when confirming an already confirmed user' do
      it 'fails' do
        post :create, params: { phone_number: confirmed_user.phone_number }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:errors]).to be_truthy
      end
    end
  end

  describe 'Put #update' do
    context 'when confirming an unconfirmed user' do
      it 'confirms the user' do
        put :update, params: { confirmation_otp: user.confirmation_otp, phone_number: user.phone_number }
        expect(response).to be_successful
        confirmed_user = User.find(json[:user][:id])
        expect(confirmed_user.confirmed?).to eq(true)
      end
    end
    context 'when confirming an already confirmed user' do
      it 'fails' do
        post :create,
          params: { confirmation_otp: confirmed_user.confirmation_otp }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
