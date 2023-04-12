# frozen_string_literal: true

RSpec.shared_examples 'create label example' do |model|
  before { post :create, params: { label: attributes } }

  it "creates a #{model.name} with the correct name" do
    expect(json[:label][:name]).to eq attributes[:name]
  end
  it "creates a #{model.name} with the correct type" do
    expect(json[:label][:label_type]).to eq(model.name.underscore)
  end

  it "increments the number of #{model.name}s by 1" do
    expect { to(change(model, :count).by(+1)) }
  end
end
