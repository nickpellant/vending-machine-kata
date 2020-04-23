# frozen_string_literal: true

require 'spec_helper'

require 'contracts/coins/create_coin_contract'
require 'repos/coin_repo'
require 'services/coins/create_coins'

RSpec.describe Services::Coins::CreateCoins do
  subject(:call) do
    described_class.call(denomination: denomination, quantity_to_load: quantity_to_load)
  end

  let(:denomination) { '1p' }
  let(:quantity_to_load) { 2 }

  let(:unvalidated_params) { { denomination: denomination, state: 'received' } }
  let(:validated_params) { unvalidated_params }

  let(:create_coin_contract) { instance_spy(Contracts::Coins::CreateCoinContract) }
  let(:coin_repo) { instance_spy(Repos::CoinRepo) }
  let(:validation_result) { instance_spy(Dry::Validation::Result) }

  before do
    allow(create_coin_contract).to(
      receive(:call).with(unvalidated_params).and_return(validation_result)
    )
    App.stub('contracts.coins.create_coin_contract', create_coin_contract)
    App.stub('repos.coin_repo', coin_repo)
  end

  context 'when coin data is valid' do
    let(:coin) { Factory.structs[:coin, :received, denomination: denomination] }

    before do
      allow(validation_result).to receive(:success?).and_return(true)
      allow(validation_result).to receive(:to_h).and_return(validated_params)

      allow(coin_repo).to(
        receive(:create)
        .with([validated_params, validated_params])
        .and_return([coin, coin])
      )
    end

    it 'validates the coin data' do
      call

      expect(create_coin_contract).to have_received(:call).with(unvalidated_params)
    end

    it 'creates the coin' do
      call

      expect(coin_repo).to(
        have_received(:create).with([validated_params, validated_params])
      )
    end

    it 'returns the created coins' do
      expect(call).to eql([coin, coin])
    end
  end

  context 'when coin data is invalid' do
    before { allow(validation_result).to receive(:success?).and_return(false) }

    it 'validates the coin data' do
      call

      expect(create_coin_contract).to have_received(:call).with(unvalidated_params)
    end

    it 'does not create a coin' do
      call

      expect(coin_repo).not_to have_received(:create)
    end

    it 'returns the validation result' do
      expect(call).to be(validation_result)
    end
  end
end
