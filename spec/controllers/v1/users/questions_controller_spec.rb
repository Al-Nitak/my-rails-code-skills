# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::Users::QuestionsController, type: :controller) do
  let(:questions) { create_list(:question, 3) }

  before do
    sign_in_user
    questions
  end

  describe 'Get #index' do
    context 'fetching all data' do
      before { get :index }
      it 'returns correct question count' do
        expect(json[:questions].count).to eq(3)
      end
    end
    context 'when searching and filtering' do
      it 'returns no results for non-existant names' do
        get :index, params: { query: 'invalid name' }
        expect(json[:questions].count).to eq(0)
      end
      it 'returns all results for a common query' do
        get :index, params: { query: 'question' }
        expect(json[:questions].count).to eq(3)
      end
    end
  end

  describe 'Get #show' do
    it 'returns the correct question given an ID' do
      get :show, params: { id: questions[0][:id] }
      expect(json[:question][:id]).to eq(questions[0][:id])
    end
  end
end
