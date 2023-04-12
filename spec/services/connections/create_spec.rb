# frozen_string_literal: true

require('rails_helper')

RSpec.describe(Connections::Create, type: :interactor) do
  let(:user_one) { create(:user) }
  let(:user_two) { create(:user) }

  let(:user_like) { create(:user_like, target: user_one, source: user_two) }
  let(:match_like) { create(:user_like, target: user_two, source: user_one) }
  let(:match_dislike_like) { create(:user_like, :dislike, target: user_two, source: user_one) }

  describe '.call' do
    before do
      user_like
    end
    context 'when user likes user' do
      subject(:context) do
        described_class.call(
          user_like: user_like
        )
      end

      it 'return without creating connection when the like doesnot match' do
        expect(context).to(be_a_success)
        expect(context.connection).to be_nil
      end
    end

    context 'when user likes user' do
      before do
        match_like
      end
      subject(:context) do
        described_class.call(
          user_like: user_like
        )
      end

      it 'Create new connection when the like match' do
        expect(context).to(be_a_success)
        connection = Connection.last
        expect(connection).to be_present
        expect(connection.connection_users.count).to eq(2)
        expect(connection.connection_users[0].user_id).to eq(user_one.id)
        expect(connection.connection_users[1].user_id).to eq(user_two.id)
      end
    end

    context 'when user likes user' do
      before do
        match_dislike_like
      end
      subject(:context) do
        described_class.call(
          user_like: user_like
        )
      end

      it 'return without creating connection when the like match but one has type dislike' do
        expect(context).to(be_a_success)
        expect(Connection.count).to(eq(0))
      end
    end
  end
end
