# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::Users::DevicesController, type: :controller) do
  let(:device) { create(:device, user: subject.current_user) }
  let(:devices) { create_list(:device, 2, user: subject.current_user) }
  let(:valid_attributes) { attributes_for(:device) }
  let(:updated_attributes) { attributes_for(:device, fcm_token: :update) }
  let(:repeated_device_identifier_attributes) { attributes_for(:device, :repeated_device_identifier) }

  before { sign_in_user }

  describe 'Post #create' do
    context 'when creating a new mac address with valid params' do
      it 'creates a device successfully' do
        post :create, params: { device: valid_attributes }
        expect(response).to be_successful
        expect(json[:device]).to be_present
      end
    end
    context 'when updating an existing mac accress with valid params' do
      it 'updates the device successfully' do
        post :create, params: { device: updated_attributes }
        expect(response).to be_successful
        expect(json[:device][:fcm_token]).to eq updated_attributes[:fcm_token].to_s
      end
    end
    context 'when creating with a repeated mac address belonging to another user' do
      it 'fails to create the the device' do
        post :create, params: { device: repeated_device_identifier_attributes }
        expect(response).to be_unprocessable
        expect(json[:device_identifier]).to be_present
      end
    end
  end

  describe 'Delete #destroy' do
    before { device }
    it 'successfully deletes a device' do
      delete :destroy, params: { device_identifier: device.device_identifier }
      expect { to(change(Device, :count).by(-1)) }
    end
  end
end
