# frozen_string_literal: true

require 'spec_helper'

require 'contracts/coin_insertions/create_coin_insertion_contract'
require 'repos/coin_insertion_repo'
require 'services/coin_insertions/create_coin_insertion'

RSpec.describe Services::CoinInsertions::CreateCoinInsertion do
  subject(:call) { described_class.call(coin: coin) }

  let(:coin) { Factory.structs[:coin, :one_pence] }
  let(:unvalidated_params) { { coin_id: coin.id, state: 'processing' } }
  let(:validated_params) { unvalidated_params }

  let(:create_coin_insertion_contract) do
    instance_spy(Contracts::CoinInsertions::CreateCoinInsertionContract)
  end
  let(:coin_insertion_repo) { instance_spy(Repos::CoinInsertionRepo) }
  let(:validation_result) { instance_spy(Dry::Validation::Result) }

  before do
    allow(create_coin_insertion_contract).to(
      receive(:call).with(unvalidated_params).and_return(validation_result)
    )
    App.stub(
      'contracts.coin_insertions.create_coin_insertion_contract', create_coin_insertion_contract
    )
    App.stub('repos.coin_insertion_repo', coin_insertion_repo)
  end

  context 'when coin insertion data is valid' do
    let(:coin_insertion) { Factory.structs[:coin_insertion, coin_id: coin.id] }

    before do
      allow(validation_result).to receive(:success?).and_return(true)
      allow(validation_result).to receive(:to_h).and_return(validated_params)

      allow(coin_insertion_repo).to(
        receive(:create).with(validated_params).and_return(coin_insertion)
      )
    end

    it 'validates the coin insertion data' do
      call

      expect(create_coin_insertion_contract).to have_received(:call).with(unvalidated_params)
    end

    it 'creates the coin insertion' do
      call

      expect(coin_insertion_repo).to have_received(:create).with(validated_params)
    end

    it 'returns the created coin insertion' do
      expect(call).to be(coin_insertion)
    end
  end

  context 'when coin insertion data is invalid' do
    before { allow(validation_result).to receive(:success?).and_return(false) }

    it 'validates the coin insertion data' do
      call

      expect(create_coin_insertion_contract).to have_received(:call).with(unvalidated_params)
    end

    it 'does not create a coin insertion' do
      call

      expect(coin_insertion_repo).not_to have_received(:create)
    end

    it 'returns the validation result' do
      expect(call).to be(validation_result)
    end
  end
end
