# frozen_string_literal: true

require 'spec_helper'

require 'contracts/coins/update_coin_quantity_in_machine_contract'
require 'repos/coin_repo'
require 'services/coins/update_coin_quantity_in_machine'

RSpec.describe Services::Coins::UpdateCoinQuantityInMachine do
  subject(:call) { described_class.call(coin: coin, quantity_to_load: quantity_to_load) }

  let(:coin) { Factory.structs[:coin] }

  let(:update_coin_quantity_in_machine_contract) do
    instance_spy(Contracts::Coins::UpdateCoinQuantityInMachineContract)
  end
  let(:coin_repo) { instance_spy(Repos::CoinRepo) }
  let(:validation_result) { instance_spy(Dry::Validation::Result) }

  before do
    allow(update_coin_quantity_in_machine_contract).to(
      receive(:call).with(unvalidated_params).and_return(validation_result)
    )
    App.stub(
      'contracts.coins.update_coin_quantity_in_machine_contract',
      update_coin_quantity_in_machine_contract
    )
    App.stub('repos.coin_repo', coin_repo)
  end

  context 'when change to quantity in machine is valid' do
    let(:quantity_to_load) { 1 }
    let(:new_quantity_in_machine) { coin.quantity_in_machine + quantity_to_load }
    let(:unvalidated_params) { { quantity_in_machine: new_quantity_in_machine } }
    let(:validated_params) { unvalidated_params }

    before do
      allow(validation_result).to receive(:success?).and_return(true)
      allow(validation_result).to receive(:to_h).and_return(validated_params)

      allow(coin_repo).to receive(:update).with(coin.id, validated_params).and_return(coin)
    end

    it 'validates the coin data' do
      call

      expect(update_coin_quantity_in_machine_contract).to(
        have_received(:call).with(unvalidated_params)
      )
    end

    it 'updates the coin' do
      call

      expect(coin_repo).to have_received(:update).with(coin.id, validated_params)
    end

    it 'returns the updated coin' do
      expect(call).to be(coin)
    end
  end

  context 'when change to quantity in machine is invalid' do
    let(:quantity_to_load) { -(coin.quantity_in_machine + 1) }
    let(:new_quantity_in_machine) { -1 }
    let(:unvalidated_params) { { quantity_in_machine: new_quantity_in_machine } }

    before { allow(validation_result).to receive(:success?).and_return(false) }

    it 'validates the coin data' do
      call

      expect(update_coin_quantity_in_machine_contract).to(
        have_received(:call).with(unvalidated_params)
      )
    end

    it 'does not update the coin' do
      call

      expect(coin_repo).not_to have_received(:update)
    end

    it 'returns the validation result' do
      expect(call).to be(validation_result)
    end
  end
end
