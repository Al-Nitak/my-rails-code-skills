# frozen_string_literal: true

require('rails_helper')

RSpec.describe(Users::SetConfirmationService, type: :interactor) do
  describe '.call' do
    context 'when user can request otp' do
      let(:user) { create(:user, :with_confirmation_otp) }
      subject(:context) do
        described_class.call(
          user: user
        )
      end

      it 'delete the last Like by current user with the conversation' do
        expect(SmsJob).to receive(:perform_later) {}
        expect(context).to(be_a_success)
      end
    end

    context 'when user has request before within 2 mins' do
      let(:user) { create(:user, :invalid_to_request_otp) }
      subject(:context) do
        described_class.call(
          user: user
        )
      end

      it 'fails' do
        expect(context).to(be_a_failure)
        expect(context.errors).to be_present
      end
    end

    context 'when user has reached max otp today' do
      let(:user) { create(:user, :reached_max_otp_per_day) }
      subject(:context) do
        described_class.call(
          user: user
        )
      end

      it 'fails' do
        expect(context).to(be_a_failure)
        expect(context.errors).to be_present
      end
    end

    context 'when user otp counter is to be reset' do
      let(:user) { create(:user, :reached_max_otp_another_day) }
      subject(:context) do
        described_class.call(
          user: user
        )
      end

      it 'fails' do
        expect(context).to(be_a_success)
        expect(context.user.otps_sent_today).to eq(1)
      end
    end
  end
end
