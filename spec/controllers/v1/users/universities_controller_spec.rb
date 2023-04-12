# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Users::UniversitiesController, type: :controller do
  let(:universities) { create_list(:university, 2) }
  let(:university) { create(:university) }
  let(:university_with_different_name) { create(:university, name: 'Test') }
  before { sign_in_user }

  describe 'Get #index' do
    context 'fetching all data' do
      before { universities }
      it 'returns correct number of universities' do
        get :index
        expect(response).to be_successful
        expect(json[:universities].count).to eq(2)
      end
    end

    context 'when searching' do
      before do
        universities
        university_with_different_name
      end
      it 'returns correct number of universities' do
        get :index, params: { query: 'Test' }
        expect(response).to be_successful
        expect(json[:universities].count).to eq(1)
      end
    end
  end
end
