# frozen_string_literal: true

# # frozen_string_literal: true
#
# require 'rails_helper'
#
# RSpec.describe(V1::Users::UsersController, type: :controller) do
#   let(:confirmed_user) { create(:confirmed_user) }
#   let(:user) { create(:user) }
#   let(:invalid_user_attributes) do
#     attributes_for(:user, :with_invalid_date, :with_long_word_description)
#   end
#   let(:valid_complete_profile_attributes) do
#     attributes_for(:user, :with_complete_profile_attributes)
#   end
#   let(:far_user) { create(:user, :far) }
#   let(:farther_user) { create(:user, :farther) }
#   let(:near_user) { create(:user, :near) }
#   let(:out_of_range_user) { create(:user, :out_of_range) }
#
#   let(:user_like) { create(:user_like, source: near_user, target_id: confirmed_user.id, like_type: :super_like) }
#
#   before { sign_in_user(confirmed_user) }
#
#   describe 'Get #Index' do
#     before do
#       far_user
#       farther_user
#       near_user
#       out_of_range_user
#     end
#     context 'when retrieving own profile' do
#       it 'returns the correct profile' do
#         get :index
#         expect(json[:users].count).to eq(3)
#         expect(json[:users][0][:id]).to eq(near_user.id)
#         expect(json[:users][1][:id]).to eq(far_user.id)
#         expect(json[:users][2][:id]).to eq(farther_user.id)
#       end
#     end
#     context 'when retrieving a user who super liked the current user' do
#       before { user_like }
#       it 'marks the retrieved user as super_liked_by' do
#         get :index
#         expect(json[:users].count).to eq(3)
#         expect(json[:users][0][:id]).to eq(near_user.id)
#         expect(json[:users][0][:super_liked_by]).to be_truthy
#         expect(json[:users][2][:id]).to eq(farther_user.id)
#         expect(json[:users][2][:super_liked_by]).to be_falsy
#       end
#     end
#   end
#
#   describe 'Get #self' do
#     context 'when retrieving own profile' do
#       it 'returns the correct profile' do
#         get :self
#         expect(json[:user][:id]).to eq(confirmed_user.id)
#       end
#     end
#   end
#
#   describe 'Get #show' do
#     context 'when retrieving another user profile' do
#       it 'returns the correct profile' do
#         get :show, params: { id: user.id }
#         expect(json[:user][:id]).to eq(user.id)
#       end
#     end
#   end
#
#   describe 'put #update' do
#     context 'when given valid params' do
#       it 'updates the user with the correct bio and completes the user profile' do
#         put :update, params: { user: valid_complete_profile_attributes }
#         expect(json[:user][:bio]).to eq(valid_complete_profile_attributes[:bio])
#       end
#     end
#
#     context 'when given invalid params' do
#       it 'fails' do
#         put :update, params: { user: invalid_user_attributes }
#         expect(response).to have_http_status(:unprocessable_entity)
#         expect(json[:word_description_length]).to be_truthy
#       end
#     end
#   end
#   describe 'delete #destroy' do
#     it 'decrements the number of users by 1' do
#       put :destroy
#       expect { to(change(User, :count).by(-1)) }
#     end
#   end
# end
