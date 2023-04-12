# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::Users::ReportsController, type: :controller) do
  let(:valid_report_attributes) { attributes_for(:report, :user_report) }
  let(:reported_user) { create(:user) }
  before { sign_in_user }

  describe 'Post #create' do
    context 'when creating with valid params' do
      # TODO: Transform this into a shared example when post entity is ready
      context 'when reporting a user' do
        it 'creates a reportable of type user with the correct text and increments the database count by 1' do
          post :create,
            params: {
              report: valid_report_attributes, user_id: reported_user.id
            }
          expect(json[:report][:text]).to eq(valid_report_attributes[:text])
          expect(json[:report][:reportable_type]).to eq 'User'
          expect { to(change(Report, :count).by(1)) }
        end
      end
    end
    context 'when creating with invalid params' do
      it 'fails to create' do
        post :create, params: { user_id: reported_user.id }
        expect(response).to have_http_status(:bad_request)
        expect(json[:error]).to be_truthy
      end
    end
  end
end
