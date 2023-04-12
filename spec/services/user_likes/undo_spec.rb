# frozen_string_literal: true

require('rails_helper')

RSpec.describe(UserLikes::Undo, type: :interactor) do
  let(:user) { create(:user) }
  let(:liked_user) { create(:user) }

  let(:user_like) { create(:user_like, source: user, target: liked_user) }

  describe '.call' do
    before do
      user_like
    end
    context 'when user undo last user' do
      subject(:context) do
        described_class.call(
          user_like: user_like,
          user: user
        )
      end

      it 'delete the last Like by current user with the connection' do
        expect(context).to(be_a_success)
        expect(context.undo.user_id).to(eq(user.id))
      end
    end
  end
end
