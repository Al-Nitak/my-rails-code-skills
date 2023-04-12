# frozen_string_literal: true

require('rails_helper')

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe(V1::Users::Posts::LikesController, type: :controller) do
  let(:user) { sign_in_user(create(:confirmed_user, :with_post_like)) }
  let(:posting) { create(:post) }
  let(:post_likes) { create_list(:post_like, 3) }
  let(:post_like) { user.post_likes.first }
  let(:liked_post) { post_like.post }
  let(:valid_attributes) do
    attributes_for(:post_like,
      post_id: posting.id, user_id: user.id)
  end

  let(:repeated_attributes) do
    attributes_for(:post_like,
      post_id: post_like.post.id, user_id: user.id)
  end

  let(:invalid_attributes) { attributes_for(:post_like, user_id: nil, post_id: nil) }

  before do
    user
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Post Like ' do
        expect(FcmJob).to receive(:perform_later) {}
        expect { post :create, params: { post_like: valid_attributes } }
          .to(change(PostLike, :count).by(1))
      end

      it 'renders a JSON response with the new course' do
        post :create, params: { post_like: valid_attributes }
        expect(response).to(have_http_status(:created))
      end
    end

    context 'with valid params after creating the same like' do
      before do
        post_like
      end
      it 'renders a JSON response with errors for the like' do
        post :create, params: { post_like: repeated_attributes }
        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the like' do
        post :create, params: { post_like: invalid_attributes }
        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      liked_post
      post_like
    end

    it 'destroys the requested Post Like' do
      expect do
        delete :destroy, params: { id: liked_post.to_param }
      end.to(change(PostLike, :count).by(-1))
    end

    it 'returns not found' do
      delete :destroy, params: { id: 'invalid' }
      expect(response).to(have_http_status(:not_found))
    end
  end
end
