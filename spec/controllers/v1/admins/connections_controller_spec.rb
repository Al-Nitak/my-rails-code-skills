# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::Admin::ConnectionsController, type: :controller) do
  let(:connections) { create_list(:connection, 2) }

  before do
    sign_in_admin
    connections
  end

  describe 'Get #index' do
    before { connections }
    context 'fetching all data' do
      it 'returns correct posts count' do
        get :index
        expect(json[:connections].count).to eq(2)
      end
    end
  end
  describe 'Get #show' do
    it 'returns the correct connection given an ID' do
      get :show, params: { id: connections[0][:id] }
      expect(json[:connection][:id]).to eq(connections[0][:id])
    end
  end
end
