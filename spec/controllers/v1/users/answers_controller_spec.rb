# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::Users::AnswersController, type: :controller) do
  let(:valid_answer_attributes) { attributes_for(:answer, :valid_answer) }
  let(:confirmed_user) { create(:confirmed_user) }
  let(:invalid_answer_attributes) do
    attributes_for(:answer, :invalid_text_image)
  end

  let(:answer) { create(:answer, user: confirmed_user) }
  let(:question) { create(:question) }
  let(:valid_answer) do
    { answer: valid_answer_attributes, question_id: question.id }
  end
  let(:invalid_answer) do
    { answer: invalid_answer_attributes, question_id: question.id }
  end
  let(:repeated_answer) do
    { answer: valid_answer_attributes, question_id: answer.question_id }
  end
  let(:non_existent_quesiton) do
    { answer: valid_answer_attributes, question_id: 0 }
  end
  let(:update_valid_answer) do
    {
      answer: valid_answer_attributes,
      question_id: answer.question_id,
      id: answer.id,
    }
  end
  let(:update_invalid_answer) do
    {
      answer: invalid_answer_attributes,
      question_id: answer.question_id,
      id: answer.id,
    }
  end

  before { sign_in_user(confirmed_user) }

  describe 'Post #create' do
    context 'when creating with valid params' do
      it 'creates an answer with the correct params and increments the database count by 1' do
        post :create, params: valid_answer
        expect(json[:answer][:text]).to eq valid_answer_attributes[:text]
        expect { to(change(Answer, :count).by(+1)) }
      end
    end

    context 'when creating with invalid params' do
      it 'fails to create' do
        post :create, params: invalid_answer
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when creating image question with invalid params' do
      let(:image_question) { create(:question, :image) }
      let(:invalid_answer_attributes) do
        attributes_for(:answer, :invalid_image_answer)
      end
      it 'fails to create' do
        post :create, params: { answer: invalid_answer_attributes, question_id: image_question.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when answering an already answered question' do
      it 'fails to create' do
        post :create, params: repeated_answer
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user exceed the limited answers' do
      before do
        sign_in_user(create(:confirmed_user, :with_max_answers))
      end
      it 'fails to create' do
        post :create, params: valid_answer
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:answer]).to be_present
      end
    end

    context 'when answering a non-existent question' do
      it 'returns not found' do
        post :create, params: non_existent_quesiton
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'Put #update' do
    context 'when updating with valid params' do
      it 'updates the question with the correct params' do
        put :update, params: update_valid_answer
        expect(json[:answer][:text]).to eq(valid_answer_attributes[:text])
      end
    end
    context 'when updating with invalid params' do
      it 'fails to update the answer' do
        put :update, params: update_invalid_answer
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'Delete #destroy' do
    context 'when deleting an answer' do
      it 'decrements the number of questions by 1' do
        put :destroy, params: { question_id: answer.question_id, id: answer.id }
        expect { to(change(Answer, :count).by(-1)) }
      end
    end
  end
end
