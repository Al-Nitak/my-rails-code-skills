# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::Users::LabelsController, type: :controller) do
  let(:main_categories) { create_list(:main_category, 2) }
  let(:interest) { create(:interest) }
  before { sign_in_user }

  describe 'Get #index' do
    before { main_categories }
    context 'fetching all data' do
      it 'returns correct label count' do
        get :index
        expect(json[:labels].count).to eq(2)
      end
    end
    context 'when searching and filtering' do
      it 'returns no results for non-existant names' do
        get :index, params: { query: 'invalid name' }
        expect(json[:labels].count).to eq(0)
      end
      it 'returns all results for a common query' do
        get :index, params: { query: 'Main' }
        expect(json[:labels].count).to eq(2)
      end
      it 'returns no results for filtering another type' do
        get :index, params: { label_type: 'post_topic' }
        expect(json[:labels].count).to eq(0)
      end
      it 'returns all results for filtering the same type' do
        get :index, params: { label_type: 'main_category' }
        expect(json[:labels].count).to eq(2)
      end
    end
  end

  describe 'Get #show' do
    before { interest }
    it 'returns the correct label given an ID' do
      get :show, params: { id: interest.id }
      expect(json[:label][:id]).to eq interest.id
    end
  end
end
