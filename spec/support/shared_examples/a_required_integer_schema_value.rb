# frozen_string_literal: true

RSpec.shared_examples 'a required integer schema value' do
  subject(:error_message) do
    described_class
      .new
      .call(params)
      .errors[value_key]
  end

  context 'when value is valid' do
    let(:params) { { value_key => 1 } }

    it { is_expected.to be_nil }
  end

  context 'when value is missing' do
    let(:params) { {} }

    it { is_expected.to eql(['is missing']) }
  end

  context 'when value is nil' do
    let(:params) { { value_key => nil } }

    it { is_expected.to eql(['must be an integer']) }
  end

  context 'when value is not an integer' do
    let(:params) { { value_key => 'string' } }

    it { is_expected.to eql(['must be an integer']) }
  end
end
