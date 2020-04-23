# frozen_string_literal: true

require 'spec_helper'
require 'support/shared_examples/a_contract_with_required_values'
require 'support/shared_examples/a_required_integer_schema_value'

require 'contracts/coin_insertions/create_coin_insertion_contract'

RSpec.describe Contracts::CoinInsertions::CreateCoinInsertionContract do
  it_behaves_like 'a contract with required values' do
    let(:required_values) { %i[coin_id] }
  end

  describe '#errors[:coin_id]' do
    it_behaves_like 'a required integer schema value' do
      let(:value_key) { :coin_id }
    end
  end
end
