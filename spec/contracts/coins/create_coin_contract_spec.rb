# frozen_string_literal: true

require 'spec_helper'
require 'support/shared_examples/a_contract_with_required_values'
require 'support/shared_examples/a_required_string_from_list_schema_value'

require 'contracts/coins/create_coin_contract'

RSpec.describe Contracts::Coins::CreateCoinContract do
  it_behaves_like 'a contract with required values' do
    let(:required_values) { %i[denomination state] }
  end

  describe '#errors[:denomination]' do
    it_behaves_like 'a required string from list schema value' do
      let(:value_key) { :denomination }
      let(:valid_values) { Entities::Coin::DENOMINATIONS }
    end
  end
  describe '#errors[:state]' do
    it_behaves_like 'a required string from list schema value' do
      let(:value_key) { :state }
      let(:valid_values) { Entities::Coin::STATES }
    end
  end
end
