# frozen_string_literal: true

require 'spec_helper'

require 'commands/vending_machine/load_coin'

RSpec.describe Commands::VendingMachine::LoadCoin do
  subject(:call) do
    described_class.call(denomination: denomination, quantity_to_load: quantity_to_load)
  end

  let(:logger) { instance_spy(Logger) }
  before { App.stub('logger', logger) }

  context 'when coin found and adding to coin quantity in machine' do
    let!(:coin) { Factory[:coin, :one_pence] }

    let(:denomination) { coin.denomination }
    let(:quantity_to_load) { 1 }
    let(:new_quantity_in_machine) { coin.quantity_in_machine + quantity_to_load }

    let(:log_coin_quantity_in_machine_updated_message) do
      "'#{denomination}' quantity in machine changed from #{coin.quantity_in_machine} to "\
      "#{new_quantity_in_machine}"
    end

    it 'updates the coin quantity in machine' do
      expect { call }.to(
        change { App['repos.coin_repo'].by_denomination(coin.denomination).quantity_in_machine }
        .from(coin.quantity_in_machine)
        .to(new_quantity_in_machine)
      )
    end

    it 'logs that the coin load was updated' do
      call

      expect(logger).to have_received(:info).with(log_coin_quantity_in_machine_updated_message)
    end
  end

  context 'when coin found and removing coin quantity than the machine has' do
    let!(:coin) { Factory[:coin, :two_pence] }

    let(:denomination) { coin.denomination }
    let(:quantity_to_load) { -(coin.quantity_in_machine + coin.quantity_in_machine + 1) }

    let(:log_coin_updating_quantity_in_machine_failed_validation_message) do
      "Attempting to load '#{denomination}' coins led to a validation error"
    end

    it 'does not change the coin quantity in machine' do
      expect { call }.not_to(
        change { App['repos.coin_repo'].by_denomination(coin.denomination).quantity_in_machine }
        .from(coin.quantity_in_machine)
      )
    end

    it 'logs that the coin load update failed validation' do
      call

      expect(logger).to(
        have_received(:error).with(log_coin_updating_quantity_in_machine_failed_validation_message)
      )
    end
  end

  context 'when coin not found' do
    let(:denomination) { '£5' }
    let(:quantity_to_load) { 1 }

    let(:log_coin_not_found_message) do
      "'#{denomination}' coin not found"
    end

    it 'logs that the coin was not found' do
      call

      expect(logger).to have_received(:error).with(log_coin_not_found_message)
    end
  end
end
