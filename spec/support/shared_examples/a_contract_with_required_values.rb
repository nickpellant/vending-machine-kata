# frozen_string_literal: true

RSpec.shared_examples 'a contract with required values' do
  subject(:validation_result) { described_class.new.call({}) }

  it 'validates required values are present' do
    expect(validation_result.errors.to_h.keys).to match_array(required_values)
  end
end
