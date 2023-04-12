# frozen_string_literal: true

require('rails_helper')

RSpec.describe(Connections::FcmNotify, type: :interactor) do
  let(:user_one) { create(:user) }
  let(:user_two) { create(:user) }
  let(:user_like) { create(:user_like, target: user_one, source: user_two) }
  let(:match_like) { create(:user_like, target: user_two, source: user_one) }

  describe '.call' do
    context 'when only one user like a user' do
      subject(:context) do
        described_class.call(
          user_like: user_like,
        )
      end
      it 'does not send a notification to the the user' do
        expect(FcmJob).not_to receive(:perform_later) {}
      end
    end

    context 'when user can request otp' do
      subject(:context) do
        described_class.call(
          user_like: match_like,
          participants: user_two
        )
      end
      it 'delete the last Like by current user with the conversation' do
        expect(FcmJob).to receive(:perform_later).twice {}
        expect(context).to(be_a_success)
      end
    end
  end
end
